/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   child_process.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/06/29 14:20:16 by sade-ara          #+#    #+#             */
/*   Updated: 2025/06/30 11:59:20 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	child1(int infile, int *pipefd, char *cmd, char **envp)
{
	dup2(infile, STDIN_FILENO);
	dup2(pipefd[1], STDOUT_FILENO);
	close(pipefd[0]);
	close(pipefd[1]);
	close(infile);
	execute_cmd(cmd, envp);
}

void	child2(int outfile, int *pipefd, char *cmd, char **envp)
{
	dup2(pipefd[0], STDIN_FILENO);
	dup2(outfile, STDOUT_FILENO);
	close(pipefd[0]);
	close(pipefd[1]);
	close(outfile);
	execute_cmd(cmd, envp);
}

void	child_error_exit(pid_t pid, int infile, int outfile)
{
	if (pid < 0)
		clear_and_error_exit(infile, outfile);
}

void	wait_child(pid_t pid1, pid_t pid2)
{
	waitpid(pid1, NULL, 0);
	waitpid(pid2, NULL, 0);
}
