#! /bin/bash

#Função para mensagens de erro.
die () {
    echo >&2 "$@"
    exit 1
}

# Teste dos argumentos de entrada
[ "$#" -eq 1 ] || die "Uso: `basename $0` <tipos de prova>. $# argumentos foram fornecidos, enquanto somente 1 é esperado."
echo $1 | grep -E -q '^[0-9]+$' || die "Argumento é um inteiro, $1 foi fornecido."

i="0";

while [ $i -lt $1 ]
  do
    k="1"
    echo "Tratando a classe de $i:"
    while [ $[$k*$1+$i] -lt 100 ]
    do
	echo -en "\t Criando link $[$k*$1+$i], conguente a $i mod $1... "
	if [ $[$k*$1+$i] -lt 10 ]
	then ln -s gabarito-0$i.html gabarito-0$[$k*$1+$i].html
	else ln -s gabarito-0$i.html gabarito-$[$k*$1+$i].html
	fi
	echo "Pronto!"
	k=$[$k+1]
    done
    echo "Pronto!"
    i=$[$i+1]
done
