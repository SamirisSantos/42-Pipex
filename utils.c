/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/06/25 10:10:59 by sade-ara          #+#    #+#             */
/*   Updated: 2025/06/25 10:10:59 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

static char	*get_path_env(char **envp)
{
	int		i;

	i = 0;
	while (envp[i])
	{
		if (ft_strncmp(envp[i], "PATH=", 5) == 0)
			return (envp[i] + 5);
		i++;
	}
	return (NULL);
}

static char	*join_and_check(char *path, char *cmd)
{
	char	*temp;
	char	*full_path;

	temp = ft_strjoin(path, "/");
	full_path = ft_strjoin(temp, cmd);
	free(temp);
	if (access(full_path, X_OK) == 0)
		return (full_path);
	free(full_path);
	return (NULL);
}

static void	ft_free(char **res)
{
	int	i;

	i = 0;
	while (res[i])
	{
		free(res[i]);
		i++;
	}
	free(res);
}

char	*get_cmd_path(char *cmd, char **envp)
{
	char	**paths;
	char	*path_env;
	char	*full_path;
	int		i;

	path_env = get_path_env(envp);
	if (!path_env)
		return (NULL);
	paths = ft_split(path_env, ':');
	i = 0;
	while (paths[i])
	{
		full_path = join_and_check(paths[i], cmd);
		if (full_path)
		{
			ft_free(paths);
			return (full_path);
		}
		i++;
	}
	ft_free(paths);
	return (NULL);
}

void	execute_cmd(char *cmd_str, char **envp)
{
	char	**cmd_args;
	char	*cmd_path;

	cmd_args = ft_split(cmd_str, ' ');
	if (!cmd_args || !cmd_args[0])
		return (perror("ERROR_CMD"), 1);
	cmd_path = get_cmd_path(cmd_args[0], envp);
	if (!cmd_path)
		return (perror("ERROR_CMD"), 1);
	execve(cmd_path, cmd_args, envp);
	perror("FAILED");
	exit(1);
}
