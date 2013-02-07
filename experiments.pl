#! /usr/bin/perl

use strict;
use warnings;

#Lero lero
print "What is your name? ";
my $name = <STDIN>;
chomp $name; #Tira o fim de linha.
print "Hello $name, how are you?\n\n";
print "Type an array of numbers: ";

#Lê e imprime
my @nums = split(' ',<STDIN>);
print "Original: @nums\n";

# Ordena
my @sorted = sort @nums;
print "Sorted: @sorted\n";

# Soma
my $sum=0;
foreach(@nums){
    $sum += $_;
}
print "The sum of them is $sum.\n";

# Lê e imprime do arquivo

my $input = './entrada.txt';

open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";


my $magic_number = $ARGV[0];

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

exit 0;
