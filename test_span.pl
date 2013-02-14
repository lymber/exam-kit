#! /usr/bin/perl

use strict;
use warnings;

# Original test LaTeX File, referres as MasterFile now on.
my $input = "./$ARGV[1]";

# Number of permutations of original test.
my $magic_number = $ARGV[0];

# Tells how many questions in this test.

open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";

my $num_quest = 0;

while ( $_ = <INPUT> ) {
    if ($_ =~ /\\begin\{questao\}/) {
	print  "Achei questão começando na linha $.\n";
	$num_quest++;
    }
}

print "A prova original contém $num_quest questões.\n";

close(INPUT);

# Get the header from MasterFile.
my $header = get_hdr();

# Get the questions from MasterFile.
my @questions = get_quest_footer();

# Dirt trick to extract the footer of MasterFile from list @questoes.
my $footer = splice(@questions, $num_quest, 1);

# Test permutation index
my $i = 0; 

# Where we actually write the permutations
while ( $i < $magic_number ) {
    my @quest_copy = @questions;
    my $output = "./prova-$i.tex";
    open(OUTPUT,">",$output) or die "Can't open $output for writing: $!\n";
    print "Gerando prova $i... ";

    select OUTPUT;

    print $header;
    @quest_copy = grab_shuf_alt(@quest_copy);
    print list_shuf(@quest_copy);
    print $footer;

    close(OUTPUT);
    
    select STDOUT;
    print "Pronto! \[ ", $#questions+1, " questões \]\n";
    $i++;
}

# Subroutines used in this program

# This subroutine extract anything from the beggining of MasterFile
# until the first ocurrence of string "\begin{questao}", that is not
# included in the returning value.
sub get_hdr {
    my $hdr='';
    open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";
    while ( ( $_ = <INPUT> ) && ( $_ !~ /\\begin\{questao\}/ ) ) {
	$hdr .= $_;
    }
    close(INPUT);
    return $hdr;
}

# This subroutine reads MasterFile and returns an array of strings with
# question statements in each position, except the last one where the
# footer of the file is stored.
sub get_quest_footer {
    open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";

    my $noBloco = 0;
    my @questoes = ();
    my $footer = '';
    my $j=0; # question number
    while (<INPUT>) {
	if (/\\begin\{questao\}/) {
	    $noBloco = 1;
	    if (/\\end\{questao\}/) {
		$noBloco = 0;
		print "\n";
	    }
	}
	if ($noBloco) {
	    $questoes[$j] .= $_;
	    if (/\\end\{questao\}/) {
		$noBloco = 0;
		$questoes[$j] .= "\n";
		$j++;
	    }
	}
	# Grabs anything after last "\end{question}" ans stores it into
	# $footer.
	if ($j==$num_quest){$_ =~ s/\\end\{questao\}//; $footer .= $_;}
    }
    close(INPUT);
    return (@questoes,$footer);
}

# This subroutine receives an array os strings, stored in @_, consisting
# of questions and shuffles it into @quest_shuf.
sub list_shuf {
    my @temp = @_;
    my @list_shuf = ();
    
    while (@temp) {
	push(@list_shuf, splice(@temp, rand @temp, 1));
    }
    return @list_shuf;
}

# This subroutine receives an array of strings, each one is a question,
# and returns it with shuffled alternatives within each question.
sub grab_shuf_alt {
    my @out;
    my $temp;

    foreach $temp (@_) {
	my @alternatives = ();
	my @lines = split("\n", $temp);
	my @linesaux = @lines;

	my $i = 0;
	my $st_statement = '';
	while ( ($i <= $#linesaux) && ($linesaux[$i] !~ /\\begin\{enumerate\}\[\\bf a\.\]/) ) {
	    $st_statement .= $linesaux[$i]."\n";
	    $i++;
	}
	
	$st_statement .= $linesaux[$i]."\n";

	while ( $i <= $#linesaux )  {
	    # need to fix match below to grab all lines of alternatives
	    if ($linesaux[$i] =~ /.*\\item.*/ ) {push(@alternatives, splice(@linesaux, $i, 1));}
	    else {$i++;}
	}

	$temp = $st_statement . join("\n",list_shuf(@alternatives)) . "\n  \\end\{enumerate\}\n\\end{questao\}\n\n";
	push(@out, $temp);
    } 
    return @out;
}

exit 0;
