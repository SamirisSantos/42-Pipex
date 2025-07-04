#!/bin/bash

# Necessario a permissao chmod +x test_pipex.sh
# execute como ./test_pipex.sh
# verificar problema de execucao
# cat -vE ./test_pipex.sh | head -n 1
# -> saida #!/bin/bash^M$ (erro)
# sed -i 's/\r$//' ./test_pipex.sh

#vlgppx='/usr/bin/valgrind --trace-children=yes --leak-check=full --track-fds=yes'

GREEN="\033[0;32m"
RED="\033[0;31m"
YEL="\033[0;33m"
RESET="\033[0m"
BOLD="\033[1m"
BLU_BG="\033[1;37;44m"

# print intro
echo -e 
echo -e "TESTER PIPEX EXERCICIO OBRIGATORIO"
echo "----------------------------------------------"
echo -e "Inicio do teste $(date +"%d %B %Y") $(date +%R)"
echo -e "by $USER on $os os"
echo -e "made by Samiris (github.com/SamirisSantos)"
echo "----------------------------------------------"

# Executa o make
MAKE_OUTPUT=$(make 2>&1)
MAKE_EXIT_CODE=$?

# Verifica se o make teve sucesso
if [ $MAKE_EXIT_CODE -ne 0 ]; then
	echo -e "${BLU_BG} Makefile ${RESET}   ===> ${RED}Erro: Make falhou: ${BOLD}TESTE CANCELADO.${RESET}"
	echo -e "$MAKE_OUTPUT"
	exit 1
else
	echo -e "${BLU_BG} Makefile ${RESET}   ===> ${GREEN}${BOLD}OK!${RESET}"
fi

# Verifica Norminette
NORMI_OUTPUT=$(find . | egrep ".*(\.c|\.h)$" | norminette)

if [[ $(echo "$NORMI_OUTPUT" | egrep -v "OK\!$") ]]; then
    echo -e "${BLU_BG} Norminette ${RESET} ===> ${RED}${BOLD}Erro:${RESET}"
    echo -e "$NORMI_OUTPUT" | egrep -v "OK\!$"
else
    echo -e "${BLU_BG} Norminette ${RESET} ===> ${GREEN}${BOLD}OK!${RESET}"
fi

# Cria o infile.txt
cat <<EOF > infile.txt
hello world
this is a test
another hello line
goodbye
HELLO in uppercase
hello world
EOF

echo -ne "\n${BLU_BG} Argumento (argc != 5): ${RESET}\n"
./pipex infile.txt "wc -l" outfile.txt > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "Teste 1 – argc < 5 ===> ${GREEN}${BOLD}OK!${RESET}"
else
    echo -e "Teste 1 – argc < 5 ===> ${RED}${BOLD}KO!${RESET}"
fi

./pipex infile.txt "ls" "grep x" "cat" outfile.txt > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "Teste 2 – argc > 5 ===> ${GREEN}${BOLD}OK!${RESET}"
else
    echo -e "Teste 2 – argc > 5 ===> ${RED}${BOLD}KO!${RESET}"
fi

# Cria o infile.txt
cat <<EOF > infile.txt
hello world
this is a test
another hello line
goodbye
HELLO in uppercase
hello world
EOF
# Teste Basico
echo -ne "\n${BLU_BG} Teste Basico: ${RESET}\n"

# Teste 1 – grep hello | wc -l
./pipex infile.txt "grep hello" "wc -l" outfile.txt
expected="3"
actual=$(cat outfile.txt)
exit_code=$?

if [[ "$actual" == "$expected" ]]; then
	echo -ne "Teste 1 – grep hello | wc -l  ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 0 ]]; then
		echo -e "${YEL}exit($exit_code) inesperado${RESET}"
		echo -ne "  ${BOLD}${YEL}exit(0) esperado${RESET}"
	else
		echo -e "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
else
	echo -e "Teste 1 – grep hello | wc -l  ===> ${RED}${BOLD}KO!${RESET}"
	echo -ne "Esperado:\n$expected"
	echo -ne "Recebido:\n$actual"
	echo -e "exit(): $exit_code"
fi

# Teste 2 – cat | wc -l"
./pipex infile.txt "cat" "wc -l" outfile.txt
expected="6"
actual=$(cat outfile.txt)
exit_code=$?

if [[ "$actual" == "$expected" ]]; then
	echo -ne "Teste 2 – cat | wc -l         ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 0 ]]; then
		echo -e "${YEL}exit($exit_code) inesperado${RESET}"
		echo -ne "  ${BOLD}${YEL}exit(0) esperado${RESET}"
	else
		echo -e "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
else
	echo -e "Teste 2 – cat | wc -l        ===> ${RED}${BOLD}KO!${RESET}"
	echo -ne "Esperado:\n$expected"
	echo -ne "Recebido:\n$actual"
	echo -e "exit(): $exit_code"
fi

# Teste 3 – grep hello | sort"
./pipex infile.txt "grep hello" "sort" outfile.txt
expected=$(
  echo -e "another hello line\nhello world\nhello world"
)
actual=$(cat outfile.txt)
exit_code=$?

if [[ "$actual" == "$expected" ]]; then
	echo -ne "Teste 3 – grep hello | sort   ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 0 ]]; then
		echo -e "${YEL}exit($exit_code) inesperado${RESET}"
		echo -ne "  ${BOLD}${YEL}exit(0) esperado${RESET}"
	else
		echo -e "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
else
	echo -e "Teste 3 – grep hello | sort  ===> ${RED}${BOLD}KO!${RESET}"
	echo -ne "Esperado:\n$expected"
	echo -ne "Recebido:\n$actual"
	echo -e "exit(): $exit_code"
fi

# Teste cmd
echo -ne "\n${BLU_BG} Teste dos cmd ${RESET}\n"

# Teste 1: cmd1 e cmd2 não existem
./pipex infile.txt "catty" "asdfg" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 1: cmd1 e cmd2 não existem      ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 127 ]]; then
		echo -ne "${YEL}${BOLD} KO!${RESET} ${YEL}exit($exit_code) inesperado${RESET}"
		echo -ne "  ${BOLD}${YEL}exit(127) esperado${RESET}"
	else
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -ne "Teste 1: cmd1 e cmd2 não existem      ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "command.*not found" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada: Command not found${RESET}"
fi

# Teste 2: cmd1 e cmd2 vazio
./pipex infile.txt " " " " outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 2: cmd1 e cmd2 vazios           ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 127 ]]; then
		echo -ne "${YEL}${BOLD} KO!${RESET} ${YEL}exit($exit_code) inesperado${RESET}"
		echo -ne "  ${BOLD}${YEL}exit(127) esperado${RESET}"
	else
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -ne "Teste 2: cmd1 e cmd2 vazios           ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "command.*not found" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada: Command not found${RESET}"
fi

# Teste 3: cmd1 existe e cmd2 não existe
./pipex infile.txt "grep hello" "asdfg" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 3: cmd2 não existe              ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 127 ]]; then
		echo -ne "${YEL}${BOLD} KO!${RESET} ${YEL}exit($exit_code) inesperado${RESET}"
		echo -ne "  ${BOLD}${YEL}exit(127) esperado${RESET}"
	else
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -ne "Teste 3: cmd2 não existe              ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "command.*not found" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada: Command not found${RESET}"
fi

# Teste 4: cmd1 existe e cmd2 vazio
./pipex infile.txt "grep hello" " " outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 4: cmd2 vazio                   ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 127 ]]; then
		echo -ne "${YEL}${BOLD} KO!${RESET} ${YEL}exit($exit_code) inesperado${RESET}"
		echo -ne "  ${BOLD}${YEL}exit(127) esperado${RESET}"
	else
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -ne "Teste 4: cmd2 vazio                   ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "command.*not found" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada: Command not found${RESET}"
fi

# Teste 5: cmd1 vazio e cmd2 existe
./pipex infile.txt " " "grep hello" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 5: cmd1 vazio                   ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 1 ]]; then
		echo -ne "${YEL}  exit($exit_code) ${YEL}${BOLD} KO!${RESET}${RESET}"
		echo -ne "   ${BOLD}${YEL}exit(1) esperado${RESET}"
	else
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -ne "Teste 5: cmd1 vazio                   ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "command.*not found" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada: Command not found${RESET}"
fi

# Teste 6: cmd1 não existe e cmd2 grep
./pipex infile.txt "catty" "grep hello" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 6: cmd1 não existe e cmd2 grep  ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 1 ]]; then
		echo -ne "${YEL}  exit($exit_code) ${YEL}${BOLD} KO!${RESET}${RESET}"
		echo -ne "   ${BOLD}${YEL}exit(1) esperado${RESET}"
	else
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -ne "Teste 6: cmd1 não existe e cmd2 grep  ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "command.*not found" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada: Command not found${RESET}"
fi

# Teste 7: cmd1 vazio e cmd2 grep
./pipex infile.txt " " "grep hello" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 7: cmd1 vazio e cmd2 grep       ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 1 ]]; then
		echo -ne "${YEL}  exit($exit_code) ${YEL}${BOLD} KO!${RESET}${RESET}"
		echo -ne "   ${BOLD}${YEL}exit(1) esperado${RESET}"
	else
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -ne "Teste 7: cmd1 vazio e cmd2 grep       ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "command.*not found" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada: Command not found${RESET}"
fi

# Teste 8: cmd1 não existe e cmd2 outro comando
./pipex infile.txt "catty" "touch oi.txt" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 8: cmd1 não existe e cmd2!=grep ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 127 ]]; then
		echo -ne "${YEL}  exit($exit_code) ${YEL}${BOLD} KO!${RESET}${RESET}"
		echo -ne "   ${BOLD}${YEL}exit(127) esperado${RESET}"
	else
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -ne "Teste 8: cmd1 não existe e cmd2!=grep ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "command.*not found" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada: Command not found${RESET}"
fi

# Teste 9: cmd1 vazio e cmd2 grep
./pipex infile.txt " " "touch oi.txt" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 9: cmd1 vazio e cmd2!=grep      ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 127 ]]; then
		echo -ne "${YEL}  exit($exit_code) ${YEL}${BOLD} KO!${RESET}${RESET}"
		echo -ne "   ${BOLD}${YEL}exit(127) esperado${RESET}"
	else
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -ne "Teste 9: cmd1 vazio e cmd2!=grep      ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "command.*not found" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada: Command not found${RESET}"
fi

# Teste PATH cmd
echo -ne "\n${BLU_BG} Teste PATH cmd: ${RESET}\n"

# Teste 1: cmd1 e cmd2 PATH existe
./pipex infile.txt "/usr/bin/ls" "/usr/bin/cat" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 1: cmd1 e cmd2 PATH existe      ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 0 ]]; then
		echo -ne "${YEL}  exit($exit_code) ${YEL}${BOLD} KO!${RESET}${RESET}"
		echo -e "   ${BOLD}${YEL}exit(0) esperado${RESET}"
	else
		echo -e "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -e "Teste 1: cmd1 e cmd2 PATH existe      ===> ${RED}${BOLD}KO!${RESET}"
fi

# Teste 2: cmd1 PATH não existe
./pipex infile.txt "/usr/bin/les" "/usr/bin/cat" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 2: cmd1 PATH não existe         ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 127 ]]; then
		echo -ne "${YEL}  exit($exit_code) ${YEL}${BOLD} KO!${RESET}${RESET}"
		echo -ne "   ${BOLD}${YEL}exit(127) esperado${RESET}"
	else
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -ne "Teste 2: cmd1 PATH não existe         ===> ${RED}${BOLD}KO!${RESET}"
fi

normalized=$(tr '[:upper:]' '[:lower:]' < stderr.txt | tr -d '[:punct:]' | tr '\0' ' ' | awk '{$1=$1};1')
expected="no such file or directory"

if [[ "$normalized" == *"$expected"* ]]; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada: No such file or directory${RESET}"
fi

# Teste 3: cmd2 PATH não existe
./pipex infile.txt "/usr/bin/cat" "/usr/bin/outro" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 3: cmd2 PATH não existe         ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -ne 127 ]]; then
		echo -ne "${YEL}  exit($exit_code) ${YEL}${BOLD} KO!${RESET}${RESET}"
		echo -ne "   ${BOLD}${YEL}exit(127) esperado${RESET}"
	else
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	fi
	else
		echo -ne "Teste 3: cmd2 PATH não existe         ===> ${RED}${BOLD}KO!${RESET}"
fi

if [[ "$normalized" == *"$expected"* ]]; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada: No such file or directory${RESET}"
fi

rm -f infile.txt outfile.txt stdout.txt stderr.txt oi.txt teste.txt

# Teste infile.txt
echo -ne "\n${BLU_BG} Teste infile.txt: ${RESET}\n"

# Cria o infile.txt
cat <<EOF > infile.txt
hello world
Here is some content
hello world
EOF
chmod a-r infile.txt

# Teste 1: infile sem permissao escrita
./pipex infile.txt "/usr/bin/ls" "/usr/bin/cat" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 1: infile sem permissao escrita         ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -eq 0 || $exit_code -eq 13 ]]; then
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	else
		echo -ne "${YEL}  exit($exit_code) ${YEL}${BOLD} KO!${RESET}${RESET}"
		echo -ne "   ${BOLD}${YEL}exit(0) ou exit(13) esperado${RESET}"
	fi
	else
		echo -ne "Teste 1: infile sem permissao escrita         ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "permission denied" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada permission denied${RESET}"
fi

rm -f infile.txt outfile.txt stdout.txt stderr.txt

# Teste 2: infile nao existe
./pipex infile.txt "/usr/bin/ls" "/usr/bin/cat" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 2: infile nao existe                    ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -eq 0 ]]; then
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	else
		echo -ne "${YEL}  exit($exit_code) ${YEL}${BOLD} KO!${RESET}${RESET}"
		echo -ne "   ${BOLD}${YEL}exit(0) esperado${RESET}"
	fi
	else
		echo -ne "Teste 2: infile nao existe                    ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "no such file or directory" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada no such file or directory${RESET}"
fi

# Teste outfile sem escrita
echo -ne "\n${BLU_BG} Teste infile sem escrita: ${RESET}\n"

# Cria o infile.txt
cat <<EOF > infile.txt
hello world
Here is some content
hello world
EOF

# Teste 1: outfile sem permissao escrita
touch outfile.txt
chmod a-w outfile.txt
./pipex infile.txt "/usr/bin/ls" "/usr/bin/cat" outfile.txt > stdout.txt 2> stderr.txt
exit_code=$?
if [[ -f outfile.txt ]]; then
	echo -ne "Teste 1: outfile sem permissao escrita         ===> ${GREEN}${BOLD}OK!${RESET}"
	if [[ $exit_code -eq 1 || $exit_code -eq 13 ]]; then
		echo -ne "  exit($exit_code) ${GREEN}${BOLD}OK!${RESET}"
	else
		echo -ne "${YEL}  exit($exit_code) ${YEL}${BOLD} KO!${RESET}${RESET}"
		echo -ne "   ${BOLD}${YEL}exit(1) ou exit(13) esperado${RESET}"
	fi
	else
		echo -ne "Teste 1: outfile sem permissao escrita         ===> ${RED}${BOLD}KO!${RESET}"
fi

if grep -iq "permission denied" stderr.txt; then
  echo -e "  Mensagem ${GREEN}${BOLD}OK!${RESET}"
else
  echo -e "  ${YEL}Mensagem esperada permission denied${RESET}"
fi

rm -f infile.txt outfile.txt stdout.txt stderr.txt
make clean > /dev/null 2>&1