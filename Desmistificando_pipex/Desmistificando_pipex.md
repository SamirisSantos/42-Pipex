🧪 Desmistificando o Pipex

🧠 Conceito rápido:
- dup2(origem, destino): redireciona o descritor de arquivo destino para apontar para o origem.
- Isso quer dizer: "quando eu usar destino, na verdade use origem".
- STDIN_FILENO → 0 → entrada padrão (normalmente teclado).
- STDOUT_FILENO → 1 → saída padrão (normalmente terminal).

🔧 Função child1
```c
void	child1(int infile, int *pipefd, char *cmd, char **envp)
{
	dup2(infile, STDIN_FILENO);
	dup2(pipefd[1], STDOUT_FILENO);
	close(pipefd[0]);
	execute_cmd(cmd, envp);
}
```

