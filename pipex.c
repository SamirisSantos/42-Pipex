/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/06/20 13:50:53 by sade-ara          #+#    #+#             */
/*   Updated: 2025/07/04 15:40:24 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

static void	open_files(int *infile, int *outfile, char **argv)
{
	*infile = open(argv[1], O_RDONLY);
	if (*infile < 0)
	{
		perror(argv[1]);
		*outfile = open(argv[4], O_CREAT | O_WRONLY | O_TRUNC, 0644);
		if (*outfile < 0)
		{
			perror(argv[4]);
			exit(1);
		}
		exit(0);
	}
	*outfile = open(argv[4], O_CREAT | O_WRONLY | O_TRUNC, 0644);
	if (*outfile < 0)
	{
		perror(argv[4]);
		if (*infile >= 0)
			close(*infile);
		exit(1);
	}
}

static void	process_pipes(char **argv, char **envp, int infile, int outfile)
{
	int		pipe_fds[2];
	pid_t	pid1;
	pid_t	pid2;

	if (pipe(pipe_fds) == -1)
		error_and_exit("pipe");
	pid1 = fork();
	if (pid1 < 0)
		error_and_exit("fork");
	if (pid1 == 0)
		child1(infile, pipe_fds, argv[2], envp);
	pid2 = fork();
	if (pid2 < 0)
		error_and_exit("fork");
	if (pid2 == 0)
		child2(outfile, pipe_fds, argv[3], envp);
	close(pipe_fds[0]);
	close(pipe_fds[1]);
	if (infile >= 0)
		close(infile);
	if (outfile >= 0)
		close(outfile);
	wait_child(pid1, pid2);
}

int	main(int argc, char **argv, char **envp)
{
	int		infile;
	int		outfile;

	if (argc != 5)
		return (1);
	open_files(&infile, &outfile, argv);
	process_pipes(argv, envp, infile, outfile);
	return (0);
}
