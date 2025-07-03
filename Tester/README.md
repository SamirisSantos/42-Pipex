# Pipex_tester_mandatory

- Adicione o arquivo test_pipex.sh na pasta do projeto
- Altere a permissao test_pipex.sh
- Execute ./test_pipex.sh

```bash
#Criar uma copia
````
## Saidas de Error
### 📂 Erros nos arquivos

🔴 infile inexistente ou sem permissão
- Ficheiro não existe
- Sem permissão de leitura.
- Falha de no open(infile, O_RDONLY).

🔴 outfile sem permissão de escrita
- O ficheiro não pode ser criado/aberto para escrita.
- Falha de no open(outfile, O_WRONLY | O_CREAT | O_TRUNC, 0644).
```bash
./pipex arquivo_inexistente.txt "grep hello"  "wc -l" outfile.txt
bash: infile: No such file or directory ## exit(0)
# cria o arquivo outfile.txt
# open() exit(1) // falhou arquivo nao existe
# grep   exit(1) // falhou arquivo nao existe
# wc -l  exit(0) // executa normalmente
bash: infile: Permission denied         ## exit(1)
bash: outfile: Permission denied        ## exit(1)
```
### 💻 Erros com comandos
🔴 cmd1 e cmd2 não existem
```bash
./pipex infile.txt "cati" "asdfg" outfile.txt

Command 'cati' not found.
Command 'asdfg' not found.
## exit(127)
```
🔴 cmd1 existe, mas cmd2 não existe ou cmd1 não existe, mas cmd2 existe
- cmd1 existe, mas cmd2 não existe ou cmd1 não existe e cmd2 não existe 
```bash
./pipex infile.txt "grep hello" "asdfg" outfile.txt
Command 'asdfg' not found.
-------------------------------------------------
./pipex infile.txt "grep hello" " " outfile.txt #comando vazio
Command ' ' not found.

ou

./pipex infile.txt "catty" "asdfg" outfile.txt
Command 'catty' not found.
Command 'asdfg' not found.
--------------------------------------------
./pipex infile.txt " " " " outfile.txt #comandos vazios
Command ' ' not found.
Command ' ' not found.
# cria o arquivo outfile.txt
## exit(127)
```
- cmd1 não existe, mas cmd2 existe
```bash
./pipex infile.txt "asdfg" "wc -l" outfile.txt
Command 'asdfg' not found.
--------------------------------------------------
./pipex infile.txt " " "wc -l" outfile.txt #comando vazio
Command ' ' not found.
# cria o arquivo outfile.txt
## exit(0)
```
*observação : Teste os comandos shell no terminal e visualize a saída*
```bash
< infile.txt catty | asdfg > outfile.txt
# apois a execucao faça
echo $?
# irá mostrar o saida do exit();
```