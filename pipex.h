/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/06/20 13:50:42 by sade-ara          #+#    #+#             */
/*   Updated: 2025/06/30 14:15:10 by sade-ara         ###   ########.fr       */
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

# define ERROR_OPEN "Error opening or invalid file\n"
# define ERROR_NOT_PER "Not permission\n"
# define ERROR_CMD "Command not found or invalid\n"
# define ERROR_MSG "Error\n"

size_t	ft_strlen(const char *c);
char	**ft_split(char const *s, char c);
char	*ft_strjoin(char const *s1, char const *s2);
void	*ft_memmove(void *dest, const void *src, size_t n);
int		ft_strncmp(const char *s1, const char *s2, size_t n);
char	*ft_strdup(const char *s1);
void	ft_free(char **arr);

int		open_infile(char *file);
int		open_outfile(char *file);
char	*get_path_env(char **envp);
char	*join_and_check(char *path, char *cmd);
char	*get_cmd_path(char *cmd, char **envp);
void	execute_cmd(char *cmd_str, char **envp);
char	*ft_strchr(const char *s, int c);

void	clear_and_error_exit(int infile, int outfile);
void	wait_child(pid_t pid1, pid_t pid2);
void	child_error_exit(pid_t pid, int infile, int outfile);
void	child1(int infile, int *pipefd, char *cmd, char **envp);
void	child2(int outfile, int *pipefd, char *cmd, char **envp);
void	parent_clean(int *pipe_fds, int infile, int outfile);

#endif