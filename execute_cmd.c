/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   execute_cmd.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/04 14:52:00 by sade-ara          #+#    #+#             */
/*   Updated: 2025/07/04 15:18:02 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

static void	handle_cmd_with_path(char *cmd_str, char **cmd_args)
{
	if (access(cmd_args[0], X_OK) != 0)
	{
		msg_cmd_not_file(cmd_str);
		ft_free(cmd_args);
		exit(127);
	}
}

static char	**parse_command(char *cmd_str)
{
	char	**args;

	args = ft_split(cmd_str, ' ');
	if (!args || !args[0])
	{
		ft_free(args);
		msg_cmd_not_found(cmd_str);
	}
	return (args);
}

void	execute_cmd(char *cmd_str, char **envp)
{
	char	**cmd_args;
	char	*cmd_path;

	cmd_args = parse_command(cmd_str);
	if (ft_strchr(cmd_args[0], '/'))
		handle_cmd_with_path(cmd_str, cmd_args);
	cmd_path = get_cmd_path(cmd_args[0], envp);
	if (!cmd_path)
	{
		ft_free(cmd_args);
		msg_cmd_not_found(cmd_str);
	}
	execve(cmd_path, cmd_args, envp);
	perror("pipex");
	ft_free(cmd_args);
	free(cmd_path);
	if (errno == EACCES)
		exit(126);
	exit(1);
}
