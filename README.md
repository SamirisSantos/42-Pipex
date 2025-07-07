# Pipex
![C Language](https://img.shields.io/badge/Language-C-blue.svg?style=flat)
![Status: In Progress](https://img.shields.io/badge/Status-In%20Progress-FFD700?style=flat)
![42 load/100](https://img.shields.io/badge/42-Load%2F100-FFD700?style=flat)
![License](https://img.shields.io/badge/license-MIT-lightgrey?style=flat)
-
## 🧪 Projeto Pipex: Guia completo

## 🧠 O que é o Pipex?

O projeto Pipex tem como objetivo te ensinar como funciona a comunicação entre processos no Unix, utilizando pipes, forks e execução de comandos, tudo em C puro.

Ele simula o seguinte comportamento do shell:
```bash
shell:< infile comando1 | comando2 > outfile
./pipex infile "comando1" "comando2" outfile
```

## 🎯 Objetivo do projeto
Criar um programa que:
- Lê de um arquivo (infile)
- Executa dois comandos em sequência, usando pipe entre eles
- A saída do primeiro vira a entrada do segundo
- Escreve o resultado final num arquivo (outfile)

## 🔧 Tecnologias e funções obrigatórias
Você deve usar:
- open, close, read, write
- pipe, dup2, fork, execve
- access, perror, strerror, malloc, free
- Manipulação de strings para dividir comandos

Você não pode usar:
- system()
- popen(), execvp() e outros atalhos de execução

## 🧱 Estrutura geral do programa
int main(int argc, char **argv, char **envp)
 - Argumentos da linha de comando: int argc, char **argv
 - Variáveis de ambiente: char **envp


Argumentos:
- argv[1]: nome do arquivo de entrada 
- argv[2]: primeiro comando (como string)
- argv[3]: segundo comando (como string)
- argv[4]: nome do arquivo de saída

Exemplo: 
./pipex infile "grep hello" "wc -l" outfile

- argv[1]: "infile"
- argv[2]: "grep hello" ← comando 1
- argv[3]: "wc -l" ← comando 2
- argv[4]: "outfile"

Dividir o argv[2] e argv[3] usando ft_split()

comando 1: "grep hello"

char **cmd_args = ft_split("grep hello", ' ');

- cmd_args[0] = "grep"
- cmd_args[1] = "hello"
- cmd_args[2] = NULL

Encontrar o caminho do comando  dentro do PATH

Usar execve() para executá-lo.
 - execve("/usr/bin/grep", cmd_args, envp);

## 🧠 Conceitos que você aprende com o Pipex
- Como processos filhos são criados com fork()
- Como eles se comunicam com pipe()
- Como substituir um processo com execve()
- Como redirecionar entrada e saída com dup2()
- Como a shell funciona por baixo dos panos

## 🧪 Tester Pipex Obrigatório

[Acesse aqui](https://github.com/SamirisSantos/42-Pipex-Tester)

## 🛟 Dicas finais
- Teste com comandos que funcionam sozinhos no terminal!
- Valide erros: arquivos que não existem, comandos inválidos, etc.
- Verifique se os descritores de ficheiro foram fechados corretamente!
- Usa valgrind para garantir que não há vazamentos de memória
```bash
valgrind ./pipex
```
- Saida do valgrind:
```bash
==XXXXX== HEAP SUMMARY:
==XXXXX==     in use at exit: 0 bytes in 0 blocks
==XXXXX==   total heap usage: 0 allocs, 0 frees, 0 bytes allocated
==XXXXX== 
==XXXXX== All heap blocks were freed -- no leaks are possible
==XXXXX== 
==XXXXX== For lists of detected and suppressed errors, rerun with: -s
==XXXXX== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```