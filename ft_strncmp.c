/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strncmp.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/04/15 16:42:36 by sade-ara          #+#    #+#             */
/*   Updated: 2025/04/15 16:44:54 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

int	ft_strncmp(const char *s1, const char *s2, size_t n)
{
	size_t	i;

	i = 0;
	if (n <= 0)
	{
		return (0);
	}
	while ((i < n) && (s1[i] == s2[i]))
	{
		if (s1[i] == '\0' || s2[i] == '\0')
			return (s1[i] - s2[i]);
		i++;
	}
	if (i == n)
	{
		return (0);
	}
	return ((unsigned char) s1[i] - (unsigned char) s2[i]);
}
// int main()
// {
//     char    st1[] = "test\200";
//     char    st2[] = "test\0";
// 	unsigned int n = 6;
// 	int	result;
// 	result = ft_strncmp(st1,st2,n);
// 	n = 4;
//  result = ft_strncmp(st1,st2,n);
//          printf("Result My funcion 1:%d \n", result);
// 	// result = strncmp(st1,st2,n);
//  printf("Result C 1:%d \n", result);
//  printf("--------------------- \n");
// 	n = 8;
// 	result = ft_strncmp(st1,st2,n);
//  printf("Result My funcion 2:%d \n", result);
//  result = strncmp(st1,st2,n);
//   printf("Result C 2:%d \n", result);
// 	printf("--------------------- \n");
// 	result = ft_strncmp(st1,st2, 9);
//  printf("Result My funcion 2:%d \n", result);
//  result = strncmp(st1,st2,9);
//  printf("Result C 2:%d \n", result);
// }