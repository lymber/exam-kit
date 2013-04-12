#! /usr/bin/perl

use strict;
use warnings;

# Check correct call of program
if ( $#ARGV != 3 ) {
    print "Usage: $0 <ano> <qual prova> <turma> <tipos de provas> \n";
    exit 0;
}

# Year
my $ano = $ARGV[0];
# Which test?
my $prova = $ARGV[1];
# Class number.
my $class = $ARGV[2];
# Number of different tests.
my $magic_number = $ARGV[3];

# Input from optical reader
my $input = "./mat2457-$ano-optica-$prova-t$class.dat";
open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";

print "Lendo respostas da turma $class... \n";

my %notas_novas = ();

while ( $_ = <INPUT> ) {
    #student id
    my $nusp = substr($_,40,7);
    if ( $nusp !~ /[0-9]{7}/) {print "  Atenção: $nusp inválido na linha $..\n";}
    #student answers
    my @answers = split('',lc(substr($_,47,16)));
    #student class
    my $turma = substr($_,77,2);
    if ( $turma !~ /0[1-9]{1}|1[0-3]{1}|20/) {print "  Aluno $nusp, turma $turma, na linha $.: não preencheu turma corretamente.\n";}
    #student test type
    my $test='';
    if ( substr($_,79,2) !~ /0[0-9]{1}|[1-9]{1}[0-9]{1}/ ){print "  Aluno $nusp, turma $turma, na linha $.: tipo de prova inválido.\n";}
    else {
	$test = substr($_,79,2) % $magic_number;
	@{$notas_novas{$nusp}} = (@answers,$test);
    }
    my $j;
    for ($j = 0; $j < $magic_number; $j++) {
	my $linha = $.;
	if ( $test eq "$j" ) {
	    my $ans_file = "./mat2457-$ano-$prova-answers-0$test.txt";
	    open(ANSWERS,"<", $ans_file) or die "Can't open $ans_file for reading: $!\n";
	    my @gabarito = split('',<ANSWERS>);
	    my $acertos = 0;
	    my $k;
	    for ( $k = 0; $k < 16; $k++ ) {
		if ( $gabarito[$k] eq $answers[$k] ) { $acertos++; }
		if ( $answers[$k] eq "*" ) {
		    print "  Erro de Leitura na questão ${\($k+1)} do aluno $nusp, turma $turma, na linha $linha. ";
		    print "Suas respostas: @answers\n";
		}
	    }
	    close(ANSWERS);
	    my $nota = round($acertos*10/16);
	    $notas_novas{$nusp}=$nota;
 	}
    }
}

print "Pronto! [${\($.)} alunos].\n";
close(INPUT);

# Starts to append new grades to the .dat file of that class.
$input = "./mat2457-$ano-t$class.dat";

unless (-e $input) {
 open(INPUT,">", $input) or die "Can't create $input: $!\n";;
 }

open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";

my %notas_atuais=();

while ($_ = <INPUT>) {
    chomp($_);
    my $nusp = substr($_,0,7);
    my $notas = substr($_,8);
    $notas_atuais{$nusp} = $notas;
}

foreach (keys %notas_novas){
    $notas_atuais{$_} .= $notas_novas{$_}." ";
}

close(INPUT);

open(OUTPUT,">", $input) or die "Can't open $input for writing: $!\n";

select OUTPUT;

foreach (sort keys %notas_atuais) {
    print "$_ $notas_atuais{$_}\n";
}
close(OUTPUT);

# Creates HTML with current grades of this class

open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";
my $output = "./mat2457-$ano-t$class.html";
open(OUTPUT,">", $output) or die "Can't open $input for writing: $!\n";

select OUTPUT;

my %table = ();
my @notas = ();

while ($_ = <INPUT>) {
    #student id
    my $nusp = substr($_,0,7);
    #student answers
    @notas = split(' ',substr($_,,8));
    @{$table{$nusp}} = @notas;
}

hdr_print($class,$#notas+1);

foreach (sort keys %table) {
    print "    <tr>\n";
    print "      <td>$_</td>\n";
    foreach (@{$table{$_}}){
    print "      <td>$_</td>\n";
    }
    print "    </tr>\n";
}

footer_print();

exit 0;

# Subroutines

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
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';
    print "<title>MAT2457 - Notas da Turma $_[0]</title>";
    print '<link rel="stylesheet" href="style.css" type="text/css"
media="screen"/>
</head>
<body>

  <table class="center" frame="box" border="1" cellpadding="1"
    cellspacing="1" summary="Notas de Prova - MAT-2457.">
    <tr>
      <th>Aluno</th>
';
    for ($i = 0; $i < $_[1]; $i++){
	if ( $i < 3 ) {print "      <th>Prova ${\($i+1)}</th>\n";}
	elsif ( $i == 3 )  {print "      <th>Prova Sub</th>\n";}
	elsif ( $i == 4 )  {print "      <th>Prova Rec</th>\n";}
    }
    print "    </tr>
";
}

sub footer_print {
    print "  </table>

</body>
</html>";
}
