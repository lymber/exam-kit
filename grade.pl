#! /usr/bin/perl

use strict;
use warnings;

# Class number.
my $class = $ARGV[0];
# Number os different tests.
my $magic_number = $ARGV[1];
# First, second, third, substitutive or rec test
my $prova = $ARGV[2];

# Insert the correct file name here when we know it
my $input = "./sample.dat";
open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";

print "Lendo respostas da turma $class... \n";

my $output=''; 
if ( $class < 10 ) {$output = "./T0${\($class+1)}.html";} 
else {$output = "./T${\($class+1)}.html";}

open(OUTPUT,">", $output) or die "Can't open $input for appending: $!\n";

select OUTPUT;
hdr_print($class,$prova);

while ( $_ = <INPUT> ) {
    #student id
    my $nusp = substr($_,40,7);
    #student answers
    my @answers = split('',lc(substr($_,47,16)));
    #student test type
    my $test = substr($_,79,2);

    my $j;
    for ($j = 0; $j < $magic_number; $j++) {
	if ( $test eq "0$j" ) {
	    my $ans_file = "./answers-$test.txt";
	    open(ANSWERS,"<", $ans_file) or die "Can't open $ans_file for reading: $!\n";
	    my @gabarito = split('',<ANSWERS>);
	    my $acertos = 0;
	    my $k;
	    for ( $k = 0; $k < 16; $k++ ) {
		if ( $gabarito[$k] eq $answers[$k] ) { $acertos++; }
		if ( $answers[$k] eq "*" ) {
		    print STDOUT "  Erro de Leitura na questão ${\($k+1)} do aluno $nusp! ";
		    print STDOUT "Suas respostas: @answers\n";
		}
	    }
	    close(ANSWERS);
	    # Dirt trick to fix rounding grades like 1.25 to 1.3
	    my $nota = $acertos*10/16+0.01;
	    body_print(($nusp,$nota));
	}
    }
}

footer_print();

close(OUTPUT);

print STDOUT "Pronto! [${\($.-1)} alunos].\n";

exit 0;

# Subroutines used in this program

# Prints HTML header for class $i
sub hdr_print {
    print '<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <style type="text/css">
      table.center{margin-left: auto; margin-right: auto;}
    </style>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';    
    print "<title>MAT2457 - Notas da Turma ${\($_[0]+1)}</title>";
    print '<link rel="stylesheet" href="style.css" type="text/css"
	  media="screen"/>
  </head>
    <body>

     <table class="center" frame="box" border="1" cellpadding="1"
	     cellspacing="1" summary="Notas de Prova - MAT-2456."> 
	<tr>
	  <th>Aluno</th>';
    print "
	  <th>Prova $_[1]</th>
	</tr>
";
}

sub body_print {
    print "
	<tr>
	  <td> $_[0] </td>";
    printf("
	  <td> %.1f </td>
	</tr>",$_[1]);
}

sub footer_print {
    print "
      </table>
  </body>
</html>";
}
