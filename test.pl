#! /usr/bin/perl

use strict;
use warnings;

# Lero lero
# print "What is your name? ";
# my $name = <STDIN>;
# chomp $name; #Tira o fim de linha.
# print "Hello $name, how are you?\n\n";
# print "Type an array of numbers: ";

# Lê e imprime
# my @nums = split(' ',<STDIN>);
# print "Original: @nums\n";

# # Ordena
# my @sorted = sort @nums;
# print "Sorted: @sorted\n";

# # Soma
# my $sum=0;
# foreach(@nums){
#     $sum += $_;
# }
# print "The sum of them is $sum.\n";

# Lê e imprime
my $input = './entrada.txt';
my $output = './saida.txt';

my $magic_number = $ARGV[0];

open(INPUT,"<", $input) or die "Can't open $input for reading: $!";

# open(OUTPUT,">",$output) or die "Can't open $output for writing: $!";

# select OUTPUT;

while( $_=<INPUT> ) {
    my @nums = split(' ',$_); 
    print "Original line: $.\n";
    print "Original data: @nums\n";

# Ordena
    my @sorted = sort @nums;
    print "Sorted: @sorted\n";

# Soma
    my $sum=0;
    foreach(@nums){
	$sum += $_;
    }
    print "The sum of them is $sum.\n";

# Embaralha

    my @temp = @nums;
    my @num_shuf = ();
    my $i = 0;
    while ($i < $magic_number){
	while (@temp) {
	    push(@num_shuf, splice(@temp, rand @temp, 1));
	}
	print "Shuffled: @num_shuf\n";
	@temp = @nums;
	@num_shuf = ();
	$i++; 
    }
    print "\n";
}

close(INPUT);

$input = './entrada.tex';
open(INPUT,"<", $input) or die "Can't open $input for reading: $!";

# my @tudo = <INPUT>;

# print "@tudo\n";

# my @teste=split('\begin{questao}',@tudo);

# my @questoes= split("\begin{questao}",@tudo);

# my $tudo;
# while (<INPUT>){
#     $tudo .= $_;
# }

# my @questoes = split(/\\begin\{questao\}/,$tudo);

# print $questoes[2];

my $start  = qr/^\*\*\* %ST_QUEST/;
my $finish = qr/^\*\*\* %END_QUEST/;


# while(<INPUT>) {
#     if ( /$start/ .. /$finish/ ) {
#         next  if /$start/ or /$finish/;
#         print $_;
#     }
# }

# my @questoes = ();
# my $i = 0;

# FEIO: while( $_ = <INPUT> ) {
#     if ($_ !~ /\\begin\{questao\}/)
#     print "Linha $.: $_";
#     if ($_ =~ /\\begin\{questao\}/) {
# 	print "Achei questão!\n";
# 	next FEIO;
#     }
#     elsif ($_ !~ /\\end\{questao\}/){
# 	$questoes[$i] .= $_;
# 	print "\\end{questao}\n\n";
# 	$i++;
#     }
#     else {print "Aqui não tinha uma questão.\n";}
# }

# print "@questoes";

close(INPUT);
# close(OUTPUT);

exit 0;
