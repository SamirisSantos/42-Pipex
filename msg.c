/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   msg.c                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/07/01 15:04:03 by sade-ara          #+#    #+#             */
/*   Updated: 2025/07/01 15:04:03 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	error_and_exit(char *msg)
{
	perror(msg);
	exit(EXIT_FAILURE);
}

void	msg_cmd_not_found(char *cmd)
{
	write(STDERR_FILENO, "Command '", 9);
	write(STDERR_FILENO, cmd, ft_strlen(cmd));
	write(STDERR_FILENO, "' not found.\n", 14);
	exit(127);
}
