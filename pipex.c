/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/06/20 13:50:53 by sade-ara          #+#    #+#             */
/*   Updated: 2025/06/20 13:50:54 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

int	open_infile(char *file)
{
	int	fd;
	fd = open(file, O_RDONLY);
	if (fd < 0)
		perror("ERROR_OPEN ");
	return (fd);
}

int	open_outfile(char *file)
{
	int	fd;
	//O_CREAT created file,O_WRONLY only write, O_TRUNC clear file
	fd = open(file, O_CREAT | O_WRONLY | O_TRUNC, 0644);
	if (fd < 0)
		perror("ERROR_OPEN ");
	return (fd);
}

void	child1(int infile, int *pipefd, char *cmd, char **envp)
{
	dup2(infile, STDIN_FILENO);
	dup2(pipefd[1], STDOUT_FILENO);
	close(pipefd[0]);
	execute_cmd(cmd, envp);
}

void	child2(int outfile, int *pipefd, char *cmd, char **envp)
{
	dup2(pipefd[0], STDIN_FILENO);
	dup2(outfile, STDOUT_FILENO);
	close(pipefd[1]);
	execute_cmd(cmd, envp);
}

int	main(int argc, char **argv, char **envp)
{
	int		infile;
	int		outfile;
	int		pipefd[2]; //pipefd[2]= {0,1} -> pipefd[0] = read, pipefd[1] = write
	pid_t	pid1;
	pid_t	pid2;

	if (argc != 5) // ./pipex(0) infile(1) "comando1"(2) "comando2"(3) outfile(4)
		return (1);
	infile = open_infile(argv[1]);
	outfile = open_outfile(argv[4]);
	if (infile < 0 || outfile < 0 || pipe(pipefd) == -1)
		return (perror("ERROR_MSG"), 1);
	pid1 = fork(); //created child process
	if (pid1 == 0)
		child1(infile, pipefd, argv[2], envp);
	pid2 = fork(); 
	if (pid2 == 0)
		child2(outfile, pipefd, argv[3], envp);
	//Parent process: closes the pipe and waits for the child
	close(pipefd[0]);
	close(pipefd[1]);
	waitpid(pid1, NULL, 0);
	waitpid(pid2, NULL, 0);
	return (0);
}

