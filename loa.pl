#! /usr/bin/perl

use strict;
use warnings;

# Number of permutations of original test.
my $magic_number = $ARGV[0];
my $i;

# Reads each version to get the correct answers
for ($i = 0; $i < $magic_number; $i++){
    my $input = "./prova-$i.tex";
    my $j;
    open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";
    print "Gerando lista de respostas para a prova tipo $i... ";
    
    while ($_ = <INPUT>){
	if ( $_ =~ /\\begin\{enumerate\}\[\\bf a\.\]/ ){$j=0;}
	if ( $_ !~ /\%\%\%\ correta/ ){$j++}
	else {print "Certa resposta! $j\n"}
    }
    close(INPUT);
    print "Pronto!\n";
}

exit 0;
