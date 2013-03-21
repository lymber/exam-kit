#! /bin/bash

#Limpeza de gabaritos clone gerados por ./clone.sh
#echo -n "Limpando gabaritos clone... "
#find . -type l -print0|xargs -0 rm
#echo "Pronto!"

#Limpeza dos gabaritos e listas de respostas gerados por loa.pl
echo -n "Limpando gabaritos e listas de repostas... "
rm -rf mat2457*.txt mat2457*.html
echo "Pronto!"

#Limpeza das provas geradas por ./test_span.pl
echo -n "Limpando provas geradas por ./test_span.pl... "
rm -rf mat2457-*.tex
echo "Pronto!"
