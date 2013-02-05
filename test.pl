#! /usr/bin/perl

use strict;
use warnings;

print "What is your name? ";
my $name = <STDIN>;
chomp $name; #Tira o fim de linha.
print "Hello $name, how are you?\n\n";
print "Type an array of numbers: ";

# Lê e imprime
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

# Embaralha
srand;
my @num_shuf = ();
while (@nums) {
    push(@num_shuf, splice(@nums, rand @nums, 1));
}
print "Shuffled: @num_shuf\n";

exit 0;
