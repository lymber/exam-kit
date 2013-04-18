#! /usr/bin/perl

use strict;
use warnings;
use Term::ANSIColor;

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
my $curr_tests = "./mat2457-$ano-t$class-$ARGV[2].dat";
open(CURRTESTS,"<", $curr_tests) or die "Can't open $curr_tests for reading: $!\n";
# Test grades to be merged
my $new_test = "./mat2457-$ano-t$class-$ARGV[3].dat";
open(NEWTEST,"<", $new_test) or die "Can't open $new_test for reading: $!\n";

# Output file
my $output = "./mat2457-$ano-t$class-$ARGV[2]$ARGV[3].dat";
open(OUTPUT,">",$output) or die "Can't open $output for reading: $!\n";

my %hash_notas = ();

while( $_ = <MATRICULADOS> ){
    chomp($_);
    # Remove quotes from name of student
    $_ =~ s/"//g;
    #student id
    my $nusp = substr($_,0,7);
    $hash_notas{$nusp} = "";
}

close(MATRICULADOS);

my %hash_divulgadas = ();
my $notas_divulgadas = '';

while( $_ = <CURRTESTS> ){
    chomp($_);
    #student id
    my $nusp = substr($_,0,7);
    #student answers 
    $notas_divulgadas = substr($_,,8);
    $hash_divulgadas{$nusp} = $notas_divulgadas;
}

close(CURRTESTS);

print color("red"), "Notas já divulgadas\n", color("reset"); 
foreach (sort keys %hash_divulgadas){
    print "\t $_ $hash_divulgadas{$_}\n"
}

my %hash_novas = ();

while( $_ = <NEWTEST> ){
    chomp($_);
    #student id
    my $nusp = substr($_,0,7);
    #student answers 
    $hash_novas{$nusp} = substr($_,,8);
}

close(NEWTEST);

print color("red"), "Notas novas\n", color("reset"); 
foreach (sort keys %hash_novas){
    print "\t $_ $hash_novas{$_}\n"
}

foreach (sort keys %hash_notas){
    if ( defined($hash_divulgadas{$_}) && defined($hash_novas{$_}) ){
	$hash_notas{$_} = $hash_divulgadas{$_}.$hash_novas{$_}." ";
    }
    elsif (defined($hash_divulgadas{$_})){
	$hash_notas{$_}=$hash_divulgadas{$_}."- "." ";
	print "$_: Não veio na P2\n"
    }
    else {
	$hash_notas{$_}="- - ";
	print "$_: Nunca veio\n";
    }
}

select OUTPUT;
foreach (sort keys %hash_notas) {
    print "$_ $hash_notas{$_}\n";
}

exit 0;
