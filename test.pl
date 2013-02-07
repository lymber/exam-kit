#! /usr/bin/perl

use strict;
use warnings;

my $magic_number = $ARGV[0];
my $input = "./$ARGV[1]";

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

my $header = get_hdr();

my $footer = '';

# '\vspace{1cm}

# \begin{center}
#   \sc{Boa Prova!}
# \end{center}

# \end{document}
# ';

my $i = 0; # test permutation index

# Fazer aqui funções do tipo pega_questoes e gera_provas

while ( $i < $magic_number ) {
    open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";
    my $output = "./prova-$i.tex";
    open(OUTPUT,">",$output) or die "Can't open $output for writing: $!\n";
    print "Gerando prova $i... ";
    select OUTPUT;

    my $noBloco = 0;
    my @questoes = ();
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
	# pega o que vier depois da última questão e vira rodapé
	if ($j==$num_quest){$_ =~ s/\\end\{questao\}//; $footer .= $_;}
    }
    print $header;
    my @temp = @questoes;
    my @quest_shuf = ();
    
    while (@temp) {
	push(@quest_shuf, splice(@temp, rand @temp, 1));
    }
    print @quest_shuf;
    print $footer;

    close(OUTPUT);
    close(INPUT);
    
    select STDOUT;
    print "Pronto! \[$j questões\]\n";
    $i++;
}

sub get_hdr {
    my $hdr='';
    open(INPUT,"<", $input) or die "Can't open $input for reading: $!\n";
    while ( ( $_ = <INPUT> ) && ( $_ !~ /\\begin\{questao\}/ ) ) {
	$hdr .= $_;
    }
    close(INPUT);
    return $hdr;
}

exit 0;
