#! /usr/bin/perl

use strict;
use warnings;
use Term::ANSIColor;

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
    if ( $nusp !~ /[0-9]{7}/) {print color("red"), "  Atenção: $nusp inválido na linha $..\n", color("reset");}
    #student answers
    my @answers = split('',lc(substr($_,47,16)));
    #student class
    my $turma = substr($_,77,2);
    if ( $turma !~ /0[1-9]{1}|1[0-3]{1}|20/) {print color("yellow"), "  Aluno $nusp, turma $turma, na linha $.: não preencheu turma corretamente.\n", color("reset");}
    #student test type
    my $test='';
    if ( substr($_,79,2) !~ /0[0-9]{1}|[1-9]{1}[0-9]{1}/ ){print color("red"), "  Aluno $nusp, turma $turma, na linha $.: tipo de prova inválido.\n", color("reset");}
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
		    print color("red"), "  Erro de Leitura na questão ${\($k+1)} do aluno $nusp, turma $turma, na linha $linha. ", color("reset");
		    print "Suas respostas: @answers\n";
		}
	    }
	    close(ANSWERS);
	    my $nota = round($acertos*10/16);
	    $notas_novas{$nusp}=$nota;
 	}
    }
}

print color("green"), "Pronto! [${\($.)} alunos].\n", color("reset");
# Class average
my $media = 0;
foreach (keys %notas_novas){
    $media += $notas_novas{$_};
}
$media = round($media/$.);
print "Média da turma: $media\n";
# Class standard deviation
my $desvpad = 0;
foreach (keys %notas_novas){
    $desvpad += ($notas_novas{$_} - $media)**2;
}
$desvpad = round(sqrt($desvpad/$.));
print "Desvio Padrão da turma: $desvpad\n";

close(INPUT);

# Creates a file with ids and new grades on this test to that class.
my $output = "./mat2457-$ano-t$class-$prova.dat";

if (-e $output) {
    print color("yellow"), "Arquivo de saída $output já existente, não vamos mexer nele. Nada gravado!\n", color("reset");}
else {
    open(OUTPUT,">", $output) or die "Can't create $output: $!\n";
    select OUTPUT;
    foreach (sort keys %notas_novas){print "$_ $notas_novas{$_}\n";};
    print "average $media\n";
    print "strddev $desvpad\n";
    close(OUTPUT);
}

select STDOUT;

exit 0;

# Subroutines

sub round {
    if ( ($_[0]*100) % 10 >= 5 ){return (int($_[0]*10+1))/10;}
    else {return (int($_[0]*10))/10}
}
