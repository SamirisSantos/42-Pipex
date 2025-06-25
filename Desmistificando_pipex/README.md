# 🧪 Desmistificando o Pipex

## 🧠 Conceito rápido:
- dup2(origem, destino) redireciona o descritor destino para usar a origem.
	- Le da origem o que o destino quer
- STDIN_FILENO → 0 → entrada padrão (normalmente teclado).
- STDOUT_FILENO → 1 → saída padrão (normalmente terminal).

## 🔧 Função child1
```c
void	child1(int infile, int *pipefd, char *cmd, char **envp)
{
	dup2(infile, STDIN_FILENO);      // entrada: infile
	dup2(pipefd[1], STDOUT_FILENO);  // saída: escrita no pipe
	close(pipefd[0]);                // fecha leitura do pipe
	execute_cmd(cmd, envp);          // executa grep hello
}
```
exemplo:
```bash
  shell infile < grep hello |  wc -l > outfile
./pipex infile "grep hello" "wc -l" outfile
```

1️⃣ dup2 (infile, STDIN_FILENO)

👉 Redireciona a entrada padrão (descritor 0) para o arquivo infile.

```bash
STDIN (0) -> infile
```
👉  grep hello vai ler o conteúdo do infile.

2️⃣ dup2 (pipefd[1], STDOUT_FILENO);

👉 Substitui a saída padrão (descritor 1) para o lado de escrita do pipe.
```bash
STDOUT (1) -> pipefd[1] 
```
👉 Tudo que grep hello imprimir será enviado para o pipe, não para o terminal.

3️⃣ close(pipefd[0]);

- Fecha pipefd[0] (lado de leitura), porque child1 só escreve.

4️⃣ execute_cmd(cmd, envp);

- Executa o comando grep hello com o stdin vindo do arquivo e o stdout indo para o pipe.
## 🔧 Função child1
```c
void	child2(int outfile, int *pipefd, char *cmd, char **envp)
{
	dup2(pipefd[0], STDIN_FILENO);     // entrada: leitura do pipe
	dup2(outfile, STDOUT_FILENO);     // saída: arquivo de saída
	close(pipefd[1]);                 // fecha escrita do pipe
	execute_cmd(cmd, envp);           // executa wc -l
}
```
1️⃣ dup2(pipefd[0], STDIN_FILENO);

👉 Redireciona a entrada padrão (stdin) para o lado de leitura do pipe (pipefd[0]).

```bash
STDIN (0) -> pipefd[0]
```
👉 wc -l vai ler o que foi enviado por grep hello.

2️⃣ dup2(outfile, STDOUT_FILENO);

👉 Redireciona a saída padrão (stdout) para o arquivo outfile.
```bash
STDOUT (1) -> outfile
```
👉 O resultado do comando (wc -l) será escrito no arquivo outfile.

3️⃣ close(pipefd[0]);

- Fecha pipefd[1] (lado de escrita), porque child2 só lê.

4️⃣ execute_cmd(cmd, envp);

- Executa o comando (wc -l) com os descritores redirecionados:
	- Lê do pipe (que tem a saída do grep hello)
	- Escreve no arquivo outfile

```bash
child1 ("grep hello"):
  stdin  <- infile
  stdout -> pipefd[1]

child2 ("wc -l"):
  stdin  <- pipefd[0]
  stdout -> outfile
-----------------------------------
         infile.txt
     ╔═════════════════════╗
     ║    hello world      ║
     ║  this is a  infile  ║
     ║     hello again     ║
     ║    no match here    ║
     ╚═════════════════════╝
            ▼
       "grep hello" (child1)
            ▼
      ╔═════════════╗
      ║    PIPE     ║
      ║ hello world ║  ← aqui passa só o texto com "hello"
      ║ hello again ║
      ╚═════════════╝
            ▼
         "wc -l" (child2)
            ▼
        outfile.txt
         ╔═════════╗
         ║    2    ║
         ╚═════════╝
-----------------------------------
```
