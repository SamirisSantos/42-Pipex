/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   child_process.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/06/29 14:20:16 by sade-ara          #+#    #+#             */
/*   Updated: 2025/07/04 14:59:21 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	child1(int infile, int *pipefd, char *cmd, char **envp)
{
	close(pipefd[0]);
	dup2(infile, STDIN_FILENO);
	dup2(pipefd[1], STDOUT_FILENO);
	close(infile);
	close(pipefd[1]);
	execute_cmd(cmd, envp);
}

void	child2(int outfile, int *pipefd, char *cmd, char **envp)
{
	close(pipefd[1]);
	dup2(pipefd[0], STDIN_FILENO);
	dup2(outfile, STDOUT_FILENO);
	close(outfile);
	close(pipefd[0]);
	execute_cmd(cmd, envp);
}

void	wait_child(pid_t pid1, pid_t pid2)
{
	int	status_child1;
	int	status_child2;
	int	exit_code;

	exit_code = 0;
	waitpid(pid1, &status_child1, 0);
	waitpid(pid2, &status_child2, 0);
	if (WIFEXITED(status_child1) && WEXITSTATUS(status_child1) != 0)
		exit_code = WEXITSTATUS(status_child1);
	if (WIFEXITED(status_child2) && WEXITSTATUS(status_child2) != 0)
		exit_code = WEXITSTATUS(status_child2);
	exit(exit_code);
}
