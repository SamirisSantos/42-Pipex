/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/06/20 13:50:42 by sade-ara          #+#    #+#             */
/*   Updated: 2025/07/04 14:13:44 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_H
# define PIPEX_H

# include <unistd.h>
# include <stdlib.h>
# include <fcntl.h>
# include <stdio.h>
# include <sys/wait.h>
# include <string.h>
# include <errno.h>

size_t	ft_strlen(const char *c);
char	*ft_strchr(const char *s, int c);
char	**ft_split(char const *s, char c);
char	*ft_strjoin(char const *s1, char const *s2);
void	*ft_memmove(void *dest, const void *src, size_t n);
int		ft_strncmp(const char *s1, const char *s2, size_t n);
char	*ft_strdup(const char *s1);
void	ft_free(char **arr);

void	error_and_exit(char *msg);
void	msg_cmd_not_found(char *cmd);
void	msg_cmd_not_file(char *cmd);

char	*get_path_env(char **envp);
char	*join_and_check(char *path, char *cmd);
char	*get_cmd_path(char *cmd, char **envp);
void	execute_cmd(char *cmd_str, char **envp);
char	*ft_strchr(const char *s, int c);

void	wait_child(pid_t pid1, pid_t pid2);
void	child1(int infile, int *pipefd, char *cmd, char **envp);
void	child2(int outfile, int *pipefd, char *cmd, char **envp);

#endif