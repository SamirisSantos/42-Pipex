# 🧪 Desmistificando o Pipex

## 🧠 Conceito essenciais:
### 🗃️ File descriptors
- Representam arquivos e I/O (entrada/saída).
	- 0 → STDIN_FILENO → entrada padrão (teclado)
	- 1 → STDOUT_FILENO → saída padrão (terminal)
	- 2 → STDERR_FILENO → saída de erro
### 🔁 dup2(origem, destino)
 - dup2(origem, destino) redireciona o descritor destino para usar a origem.
	- Le da origem o que o destino quer
### 🍴 fork()
- Cria um novo processo filho.
- Pai recebe pid > 0, filho recebe pid == 0.
### 🧪 execve(path, args, env)
- Substitui o processo atual por um novo processo.
- Se funcionar, o processo atual deixa de existir — ele vira o novo programa.
- Se falhar, usar perror() e exit(1).
### 📬 pipe(pipefd)
- pipefd[0] (read)
- pipefd[1] (write)
### ⏳ waitpid(pid, NULL, 0)
- Espera o processo com aquele pid terminar.
### 📂 Permissões e abertura de arquivos
- open(const char *pathname, int flags, mode_t mode)
	- O_RDONLY: Abrir somente para leitura
	- O_WRONLY: Abrir somente para escrita
	- O_CREAT: Criar o arquivo se ele não existir
	- O_TRUNC: 	Se o arquivo já existir, apaga o conteúdo ao abrir

## 🔧 Função child1
```c
void	child1(int infile, int *pipefd, char *cmd, char **envp)
{
	dup2(infile, STDIN_FILENO);      // entrada: infile
	dup2(pipefd[1], STDOUT_FILENO);  // saída: escrita no pipe
	close(pipefd[0]);                // fecha leitura do pipe
	close(pipefd[1]);                // fecha escrita do pipe
	close(infile);                   // fecha arquivo de entrada
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

## 🔧 Função child2
```c
void	child2(int outfile, int *pipefd, char *cmd, char **envp)
{
	dup2(pipefd[0], STDIN_FILENO);     // entrada: leitura do pipe
	dup2(outfile, STDOUT_FILENO);     // saída: arquivo de saída
	close(pipefd[0]);                // fecha leitura do pipe
	close(pipefd[1]);                // fecha escrita do pipe
	close(outfile);                  // fecha arquivo de saída
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
## 🔧 Função Pai - Pipex
O processo pai  atua como o controlador do programa, responsável por preparar os arquivos, criar o pipe e os processos filhos.

Validacao dos argumentos
- argc tem que ser igual a 5
```bash
./pipex infile "cmd1" "cmd2" outfile
  (1)    (2)     (3)   (4)     (5)
```

Criação do pipe
```c
pipe(pipefd);
//pipefd[0]: para leitura
//pipefd[1]: para escrita
```
Criar os processos filhos com fork()

👶 primeiro filho - executa o comando 1
```c
pid1 = fork();
if (pid1 == 0)
	child1(infile, pipefd, argv[2], envp);
```

👶 segundo filho - executa o comando 2
```c
pid2 = fork();
if (pid2 == 0)
	child2(outfile, pipefd, argv[3], envp);
```

👨 Processo pai – Coordenação e espera
```c
// fecha as pipes pois nao vai utilizar mais
close(pipefd[0]);
close(pipefd[1]);
// aguarda os dois filhos terminarem de executar
// garante que o processo principal não finalize antes dos filhos
waitpid(pid1, NULL, 0);
waitpid(pid2, NULL, 0);
```
```bash
         infile.txt
             │
             ▼
   👶 Filho 1: [ grep hello ]
             │
      dup2 → pipefd[1]
             ▼
       ╔════════════╗
       ║    PIPE    ║
       ╚════════════╝
             │
      dup2 ← pipefd[0]
             ▼
   👶 Filho 2: [ wc -l ]   
             │
             ▼
         outfile.txt
```
## Comportamento das funções no utils.c
```c
char	*get_path_env(char **envp);
char	*join_and_check(char *path, char *cmd);
char	*get_cmd_path(char *cmd, char **envp);
void	execute_cmd(char *cmd_str, char **envp);
```
1️⃣ O **pipex** executa um comando (ex: "grep hello"), e **execute_cmd**

2️⃣ O **get_path_env** localizar o valor da variável **PATH** no ambiente
```c
envp[0] = "USER=user"
envp[1] = "PATH=/usr/local/bin:/usr/bin:/bin"

//retorno: "/usr/local/bin:/usr/bin:/bin"
```
3️⃣ O **join_and_check** juntar um diretório com o nome do comando, no exemplo ele verificaria se grep existe, e verificar se o executável existe.
```c
path = "/usr/bin"
cmd  = "grep"
-------------------
//ver e verifixa
ft_strjoin("/usr/bin", "/") + ft_strjoin(..., "grep") → "/usr/bin/grep"
access("/usr/bin/grep", X_OK)
```
4️⃣ O **get_cmd_path** pega o caminho do executavel e testa os diretorios
```c
cmd = "grep"
-------------------
//retorno "/usr/bin/grep" 
```
5️⃣ O **execute_cmd** executá-lo com execve
```c
cmd_str = "grep hello"
```
✅ Fluxo
```c
execute_cmd("grep hello", envp)
   └─▶ ft_split → ["grep", "hello", NULL]
        └─▶ get_cmd_path("grep", envp)
             └─▶ get_path_env(envp) → "/usr/bin:/bin:..."
             └─▶ ft_split(PATH)
             └─▶ join_and_check(dir, "grep") → "/usr/bin/grep"
        └─▶ execve("/usr/bin/grep", ["grep", "hello", NULL], envp)
```
Outra visualização
```bash
 ./pipex infile.txt "grep hello" "wc -l" outfile
 argv[0] = ./pipex
 argv[1] = infile
 argv[2] = "grep hello"
 argv[3] = "wc -l"
 argv[4] = outfile.txt
--------------------------
argv[2] = "grep hello"
       │
       ▼
void execute_cmd("grep hello", envp)
       │
       ▼
┌─────────────────────────────────────────┐
│ ft_split("grep hello", ' ')             │
│ → cmd_args = ["grep", "hello", NULL]    │
└─────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────┐
│ get_cmd_path(cmd_args[0], envp)         │
│ → chama get_path_env(envp)              │
└─────────────────────────────────────────┘
       │
       ▼
path_env = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
       │
       ▼
ft_split(path_env, ':')
→ paths = ["/usr/local/bin", "/usr/bin", "/bin", ...]
       │
       ▼
Loop com join_and_check:
───────────────────────────────────────────────
i = 0 → "/usr/local/bin/grep" → ❌
i = 1 → "/usr/bin/grep"       → ✅ encontrado!
───────────────────────────────────────────────
       │
       ▼
Retorna: "/usr/bin/grep"
       │
       ▼
execve("/usr/bin/grep", ["grep", "hello", NULL], envp)
       │
       ▼
Substitui o processo atual pelo comando grep
```