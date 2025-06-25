/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/06/20 13:50:42 by sade-ara          #+#    #+#             */
/*   Updated: 2025/06/25 10:15:31 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_H
# define PIPEX_H

# include <unistd.h>
# include <stdlib.h>
# include <fcntl.h>
# include <stdio.h>
//# include <sys/wait.h>
# include <string.h>

# define ERROR_OPEN "Error opening file\n"
# define ERROR_CMD "command not found or invalid\n"
# define ERROR_MSG "Error\n"


char	**ft_split(char const *s, char c);
char	*ft_strjoin(char const *s1, char const *s2);

int		open_infile(char *file);
int		open_outfile(char *file);
void	child1(int infile, int *pipefd, char *cmd, char **envp);
void	child2(int outfile, int *pipefd, char *cmd, char **envp);

static char	*get_path_env(char **envp);
static char	*join_and_check(char *path, char *cmd);
static void	ft_free(char **res);
char	*get_cmd_path(char *cmd, char **envp);
void	execute_cmd(char *cmd_str, char **envp);


#endif

