#! /usr/bin/perl

use strict;
use warnings;

# Number of permutations of original test.
my $magic_number = $ARGV[0];
my $i;


# Reads each version to get the correct answers
for ($i = 0; $i < $magic_number; $i++){
    my $input = "./prova-$i.tex";
    open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";
    print "Gerando gabarito para prova em HTML para a prova tipo $i... ";

    my $output = "./gabarito-$i.html";
    open(HTML, ">",$output) or die "Can't open $output for writing: $!\n";

    select HTML;
    hdr_print($i);

    my $j; # Counter of read alternatives;
    my @answers = ();
    while ($_ = <INPUT>){
	if ( $_ =~ /\\begin\{enumerate\}\[\\bf a\.\]/ ){$j=0;}
	if ( $_ !~ /\%\%\%\ correta/ ){$j++}
	else {push(@answers,chr($j+96));}
    }

    body_print(@answers);

    close(INPUT);
    close(HTML);

    select STDOUT;
    print "Pronto!\n";

    print "Gerando arquivo texto com as respostas para a prova tipo $i... ";
    $output = "./answers-$i.txt";
    open(ANSWERS, ">",$output) or die "Can't open $output for writing: $!\n";
    select ANSWERS;
    print @answers;

    select STDOUT;
    print "Pronto!\n";
}

exit 0;

# Subroutines used in this program

# Prints HTML header for test $i
sub hdr_print {
    print '<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <style type="text/css">
      table.center{margin-left: auto; margin-right: auto;}
    </style>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';    
    print "<title>MAT2457 - Gabarito Prova Tipo $_[0]</title>";
    print '<link rel="stylesheet" href="style.css" type="text/css"
	  media="screen"/>
  </head>';
}

sub body_print {
    my $num_quest = 16; #number of questions
    my $i;
    print '  <body>

     <table class="center" frame="box" border="1" cellpadding="1"
	     cellspacing="1" summary="Locais de Prova - MAT-2456."> 
	<tr>
	  <th>Questão</th>
	  <th>Resposta</th>
	</tr>';
    for ($i = 0; $i < $num_quest; $i++) {
	print "
	<tr>
	  <td> ${\($i+1)} </td>
	  <td> $_[$i]</td>
	</tr>";
    }
    print "
      </table><br />
  </body>
</html>";
}