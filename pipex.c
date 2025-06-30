/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/06/20 13:50:53 by sade-ara          #+#    #+#             */
/*   Updated: 2025/06/30 12:00:06 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

int	open_infile(char *file)
{
	int	fd;

	fd = open(file, O_RDONLY);
	if (fd < 0)
		perror(ERROR_OPEN);
	return (fd);
}

int	open_outfile(char *file)
{
	int	fd;

	fd = open(file, O_CREAT | O_WRONLY | O_TRUNC, 0644);
	if (fd < 0)
		perror(ERROR_OPEN);
	return (fd);
}

void	clear_and_error_exit(int infile, int outfile)
{
	if (infile != -1)
		close(infile);
	if (outfile != -1)
		close(outfile);
	perror(ERROR_MSG);
	exit(1);
}

void	parent_clean(int *pipe_fds, int infile, int outfile)
{
	close(pipe_fds[0]);
	close(pipe_fds[1]);
	close(infile);
	close(outfile);
}

int	main(int argc, char **argv, char **envp)
{
	int		pipe_fds[2];
	int		infile;
	int		outfile;
	pid_t	pid1;
	pid_t	pid2;

	if (argc != 5)
		return (1);
	infile = open_infile(argv[1]);
	outfile = open_outfile(argv[4]);
	if (infile < 0 || outfile < 0)
		return (1);
	if (pipe(pipe_fds) == -1)
		clear_and_error_exit(infile, outfile);
	pid1 = fork();
	child_error_exit(pid1, infile, outfile);
	if (pid1 == 0)
		child1(infile, pipe_fds, argv[2], envp);
	pid2 = fork();
	child_error_exit(pid2, infile, outfile);
	if (pid2 == 0)
		child2(outfile, pipe_fds, argv[3], envp);
	parent_clean(pipe_fds, infile, outfile);
	wait_child(pid1, pid2);
	return (0);
}
