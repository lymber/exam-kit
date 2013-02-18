#! /usr/bin/perl

use strict;
use warnings;

# Class number.
my $class = $ARGV[0];
# Number of different tests.
my $magic_number = $ARGV[1];
# First, second, third, substitutive or rec test
my $prova = $ARGV[2];

# Insert the correct file name here when we know it
my $input = "./sample$prova.dat";
open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";

print "Lendo respostas da turma $class... \n";

my %notas_novas = ();

while ( $_ = <INPUT> ) {
    #student id
    my $nusp = substr($_,40,7);
    #student answers
    my @answers = split('',lc(substr($_,47,16)));
    #student test type
    my $test = substr($_,79,2);

    @{$notas_novas{$nusp}} = (@answers,$test);

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
		    print "  Erro de Leitura na questão ${\($k+1)} do aluno $nusp! ";
		    print "Suas respostas: @answers\n";
		}
	    }
	    close(ANSWERS);
	    my $nota = $acertos*10/16;
	    $notas_novas{$nusp}=$nota;
 	}
    }
}

print "Pronto! [${\($.-1)} alunos].\n";
close(INPUT);

# Starts to append new grades to the .dat file of that class.
$input = "./T${\($class+1)}.dat";

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

open(OUTPUT,">", $input) or die "Can't open $input for appending: $!\n";

select OUTPUT;

foreach (sort keys %notas_atuais) {
    print "$_ $notas_atuais{$_}\n";
}
close(OUTPUT);

exit 0;
