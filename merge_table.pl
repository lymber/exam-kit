#! /usr/bin/perl

use strict;
use warnings;
use Term::ANSIColor;

# First run (inicialization of the file)
if ( $#ARGV == 2 ){
    # Year
    my $ano = $ARGV[0];
    # Class Number
    my $class = $ARGV[1];
    # Enrolled students
    my $matriculados = "../dados/mat2457-$ano-matriculados-t$class.csv";
    open(MATRICULADOS,"<", $matriculados) or die "Can't open $matriculados for reading: $!\n";
    # Tests grades already annouced
    my $curr_tests = "./mat2457-$ano-t$class-$ARGV[2].dat";
    open(CURRTESTS,"<", $curr_tests) or die "Can't open $curr_tests for reading: $!\n";
    # Output
    my $output = "./mat2457-$ano-t$class-pronto-$ARGV[2].dat";
    open(OUTPUT,">", $output) or die "Can't open $output for writing: $!\n";

    my %hash_notas = ();
    
    while( $_ = <MATRICULADOS> ){
	chomp($_);
	# Remove quotes from name of student
	$_ =~ s/"//g;
	#student id
	my $nusp = substr($_,0,7);
	$hash_notas{$nusp} = "";
    }
    $hash_notas{average} = "";
    $hash_notas{strddev} = "";
    close(MATRICULADOS);
    
    my %hash_divulgadas = ();
    my $notas_divulgadas = "";
    
    while( $_ = <CURRTESTS> ){
	chomp($_);
	#student id
	my $nusp = substr($_,0,7);
	#student grades 
	$notas_divulgadas = substr($_,,8);
	$hash_divulgadas{$nusp} = $notas_divulgadas;
    }
    foreach (sort keys %hash_notas){
	if ( !defined($hash_divulgadas{$_}) ){$hash_notas{$_}="- ";}
	else{$hash_notas{$_}=$hash_divulgadas{$_}." ";}
    }
    
    select OUTPUT;
    foreach (sort keys %hash_notas) {
	print "$_ $hash_notas{$_}\n";
    }
    close(OUTPUT);

    select STDOUT;
    print color("green"), "Pronto! [Arquivo com as notas da primeira prova preparado.]\n", color("reset");

    print "Gerando o arquivo HTML... ";

    # Time to write the HTML file

    #We use the new shining merged dat file to create HTML table
    my $merged_file = $output;

    open(MERGED_FILE,"<",$merged_file) or die "Can't open $merged_file for reading: $!\n";

    my %table = ();
    my @notas_line = ();
    
    while ($_ = <MERGED_FILE>) {
	chomp($_);
	#student id
	my $nusp = substr($_,0,7);
	#student answers
	@notas_line = split(' ',substr($_,,8));
	@{$table{$nusp}} = @notas_line;
    }
    close(MERGED_FILE);

    my $html_file = "./mat2457-$ano-t$class.html";
    open(HTML_FILE,">",$html_file) or die "Can't open $html_file for writing: $!\n";

    select HTML_FILE;
    
    hdr_print($class);

    my $i=0;
    my $bgcolor;
    foreach (sort keys %table) {
	if ($i %2 == 0) {$bgcolor="claro";}
	else{$bgcolor="escuro";}
	if ($_ eq "average" || $_ eq "strddev"){$bgcolor="header";}
	$i++;
	print "    <tr class=\"$bgcolor\">\n";
	if ($_ =~ /[0-9]{7}/){print "      <td>$_</td>\n";}
	elsif ($_ eq "average"){print "      <td><strong>Média</strong></td>\n";}
	else{print "      <td><strong>Desvio Padrão<strong></td>\n";}
	foreach (@{$table{$_}}){print "      <td>$_</td>\n";}
	for (my $j=$#{$table{$_}}; $j<4; $j++){print "      <td></td>\n";}
	print "    </tr>\n";
    }

    footer_print();

    close(HTML_FILE);

    select STDOUT;
    print "Pronto!\n";
    exit 0;
}

# Check correct call of program
if ( $#ARGV != 3 || $ARGV[0] !~ /[0-9]{4}/ || $ARGV[1] !~ /0[1-9]{1}|1[0-3]{1}|20/) {
    print "Usage: $0 <ano> <turma> <current_tests> <newtest>\n";
    exit 0;
}

# Year
my $ano = $ARGV[0];
# Class Number
my $class = $ARGV[1];

# Enrolled students
my $matriculados = "../dados/mat2457-$ano-matriculados-t$class.csv";
open(MATRICULADOS,"<", $matriculados) or die "Can't open $matriculados for reading: $!\n";

# Tests grades already annouced
my $curr_tests = "./mat2457-$ano-t$class-pronto-$ARGV[2].dat";
open(CURRTESTS,"<", $curr_tests) or die "Can't open $curr_tests for reading: $!\n";
# Test grades to be merged
my $new_test = "./mat2457-$ano-t$class-$ARGV[3].dat";
open(NEWTEST,"<", $new_test) or die "Can't open $new_test for reading: $!\n";

my %hash_notas = ();

while( $_ = <MATRICULADOS> ){
    chomp($_);
    # Remove quotes from name of student
    $_ =~ s/"//g;
    #student id
    my $nusp = substr($_,0,7);
    $hash_notas{$nusp} = "";
}
$hash_notas{average} = "";
$hash_notas{strddev} = "";
close(MATRICULADOS);

my %hash_divulgadas = ();
my $notas_divulgadas = "";

while( $_ = <CURRTESTS> ){
    chomp($_);
    #student id
    my $nusp = substr($_,0,7);
    #student grades
    $notas_divulgadas = substr($_,,8);
    $hash_divulgadas{$nusp} = $notas_divulgadas;
}
close(CURRTESTS);

my %hash_novas = ();
while( $_ = <NEWTEST> ){
    chomp($_);
    #student id
    my $nusp = substr($_,0,7);
    #student grades
    $hash_novas{$nusp} = substr($_,,8);
}
close(NEWTEST);

foreach (sort keys %hash_notas){
    if ( defined($hash_divulgadas{$_}) && defined($hash_novas{$_}) ){
	$hash_notas{$_} = $hash_divulgadas{$_}.$hash_novas{$_}." ";
    }
    elsif (defined($hash_divulgadas{$_})){
	$hash_notas{$_}=$hash_divulgadas{$_}."- ";
    }
    else {$hash_notas{$_}="- ";}
}

# Output file
my $output = "./mat2457-$ano-t$class-pronto-$ARGV[2]$ARGV[3].dat";
open(OUTPUT,">",$output) or die "Can't open $output for writing: $!\n";

select OUTPUT;
foreach (sort keys %hash_notas) {
    print "$_ $hash_notas{$_}\n";
}
close(OUTPUT);

select STDOUT;

print color("green"),"Pronto! [Arquivos intercalados]\n",color("reset");

print "Gerando arquivo HTML... ";

# Time to write the HTML file

#We use the new shining merged dat file to create HTML table
my $merged_file = $output;
open(MERGED_FILE,"<",$merged_file) or die "Can't open $merged_file for reading: $!\n";

my %table = ();
my @notas_line = ();

while ($_ = <MERGED_FILE>) {
    chomp($_);
    #student id
    my $nusp = substr($_,0,7);
    #student answers
    @notas_line = split(' ',substr($_,,8));
    @{$table{$nusp}} = @notas_line;
}

close(MERGED_FILE);

my $html_file = "./mat2457-$ano-t$class.html";
open(HTML_FILE,">",$html_file) or die "Can't open $html_file for writing: $!\n";

select HTML_FILE;

hdr_print($class);

my $i=0;
my $bgcolor;
foreach (sort keys %table) {
    if ($i %2 == 0) {$bgcolor="claro";}
    else{$bgcolor="escuro";}
    if ($_ eq "average" || $_ eq "strddev"){$bgcolor="header";}
    $i++;
    print "    <tr class=\"$bgcolor\">\n";
    if ($_ =~ /[0-9]{7}/){print "      <td>$_</td>\n";}
    elsif ($_ eq "average"){print "      <td><strong>Média</strong></td>\n";}
    else{print "      <td><strong>Desvio Padrão<strong></td>\n";}
    my @provas = ();
    my $j=0;
    foreach (@{$table{$_}}){
	print "      <td>$_</td>\n";
	$provas[$j]=$_;
	$j++;
    }

    my $fez_sub = 0;
    if ($provas[3] ne "-") {$fez_sub = 1}

    my $fez_rec = 0;
    if ($provas[4] ne "-") {$fez_rec = 1}

    foreach (@provas){
	if ($_ eq "-") {$_=0;}
    }

    my $com_sub;
    if ($fez_sub) {
	my @medias = (sprintf("%.1f",(2*$provas[3]+3*$provas[1]+3*$provas[2])/8+1/1024), sprintf("%.1f",(2*$provas[0]+3*$provas[3]+3*$provas[2])/8+1/1024), sprintf("%.1f",(2*$provas[0]+3*$provas[1]+3*$provas[3])/8+1/1024));
	$com_sub = max(@medias);
    }
    else {$com_sub = sprintf("%.1f",(2*$provas[0]+3*$provas[1]+3*$provas[2])/8+1/1024);
    };
 
    my $final;
    if ($fez_rec) {
	$final = sprintf("%.1f",(2*$com_sub+3*$provas[4])/5+1/1024)
    }
    else {$final = $com_sub;};

    for (my $j=$#{$table{$_}}; $j<4; $j++){print "      <td></td>\n";}

    if ($com_sub >= 5) {print "      <td class=\"passou\">$com_sub</td>\n";}
    elsif ($com_sub < 3) {print "      <td class=\"bombou\">$com_sub</td>\n";}
    else {print "      <td class=\"rec\">$com_sub</td>\n";}

    if ($final >= 5) {print "      <td class=\"passou\">$final</td>\n";}
    else {print "      <td class=\"bombou\">$final</td>\n";}
    print "    </tr>\n";
}

footer_print();

close(HTML_FILE);

select STDOUT;
print "Pronto!\n";

exit 0;

#Subroutines

sub max {
    my $loc_max=0;
    my $cur_avg;

    foreach $cur_avg (@_) {
	if ($cur_avg > $loc_max) {$loc_max = $cur_avg}
    }
    return $loc_max;
}

sub round {
    if ( ($_[0]*100) % 10 >= 5 ){return (int($_[0]*10+1))/10;}
    else {return (int($_[0]*10))/10}
}

sub hdr_print {
    my $i;
    print '<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<style type="text/css">
  table.center{margin-left: auto; margin-right: auto;}
  tr.header{background-color: #909090;}
  tr.branco{background-color: white;}
  tr.escuro{background-color: #bcbcbc;}
  td.passou{color: seagreen}
  td.bombou{color: darkred}
  td.rec{color: darkgoldenrod}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';
    print "<title>MAT2457 - Notas da Turma $_[0]</title>";
    print '<link rel="stylesheet" href="style.css" type="text/css"
media="screen"/>
</head>
<body>

  <table class="center" frame="box" border="1" cellpadding="1"
    cellspacing="1" summary="Notas de Prova - MAT-2457.">
    <tr class="header">
      <th>Aluno</th>
      <th>Prova 1</th>
      <th>Prova 2</th>
      <th>Prova 3</th>
      <th>Prova Sub</th>
      <th>Prova Rec</th>
      <th>Média s/ Rec.</th>
      <th>Média Final</th>
    </tr>
';
}

sub footer_print {
    print "  </table>

</body>
</html>";
}
