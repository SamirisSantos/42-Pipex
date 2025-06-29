/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strjoin.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sade-ara <sade-ara@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/04/23 15:25:31 by sade-ara          #+#    #+#             */
/*   Updated: 2025/04/23 16:21:21 by sade-ara         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

size_t	ft_strlen(const char *c)
{
	int	i;

	i = 0;
	while (c[i] != '\0')
	{
		i++;
	}
	return (i);
}

void	*ft_memmove(void *dest, const void *src, size_t n)
{
	size_t		i;
	char		*d;
	const char	*s;

	d = dest;
	s = src;
	if (!dest && !src)
		return (NULL);
	i = 0;
	while ((d < s) && (i < n))
	{
		d[i] = s[i];
		i++;
	}
	while ((d > s) && (n > 0))
	{
		n--;
		d[n] = s[n];
	}
	return (dest);
}

char	*ft_strjoin(char const *s1, char const *s2)
{
	size_t	len_s1;
	size_t	len_s2;
	char	*strjoin;

	len_s1 = ft_strlen((char *)s1);
	len_s2 = ft_strlen((char *)s2);
	strjoin = (char *)malloc(sizeof(char) * (len_s1 + len_s2 + 1));
	if (strjoin == NULL)
		return (0);
	ft_memmove ((void *)strjoin, (const void *)s1, len_s1);
	ft_memmove ((void *)strjoin + len_s1, (const void *)s2, len_s2 + 1);
	return (strjoin);
}
// int main()
// {
// 	char s1[] = "Good";
// 	char s2[] = " Morning";
// 	char *rest;

// 	rest = ft_strjoin(s1,s2);
// 	printf("%s\n", rest);
// 	free(rest);
//     return 0;
// }