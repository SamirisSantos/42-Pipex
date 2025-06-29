#!/bin/bash

# Compila se necessário
# make
# de a permissao chmod +x test_pipex.sh
# execute como ./test_pipex.sh
# Cria ficheiro de entrada
cat <<EOF > infile.txt
hello world
this is a test
another hello line
goodbye
HELLO in uppercase
EOF

echo -e "\n🔎 Teste 1 – grep hello | wc -l"
./pipex infile.txt "grep hello" "wc -l" outfile.txt
echo -n "Resultado: "
cat outfile.txt

echo -e "\n🔎 Teste 2 – cat | grep test"
./pipex infile.txt "cat" "grep test" outfile.txt
echo "Resultado:"
cat outfile.txt

echo -e "\n🔎 Teste 3 – grep nothing | wc -l"
./pipex infile.txt "grep nothing" "wc -l" outfile.txt
echo -n "Resultado: "
cat outfile.txt

echo -e "\n🔎 Teste 4 – comando inválido"
./pipex infile.txt "falso_cmd" "wc -l" outfile.txt
echo -n "Resultado: "
cat outfile.txt

echo -e "\n🔎 Teste 5 – tr A-Z | grep HELLO"
./pipex infile.txt "tr a-z A-Z" "grep HELLO" outfile.txt
echo "Resultado:"
cat outfile.txt

echo -e "\n🔎 Teste 6 – infile inexistente"
./pipex naoexiste.txt "cat" "wc -l" outfile.txt
echo -n "Resultado: "
cat outfile.txt

# Limpeza
rm -f infile.txt outfile.txt
