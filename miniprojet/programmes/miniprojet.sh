#!/usr/bin/env bash

if [ $# -ne 1 ]
then
	echo "Le script attend exactement un argument"
	exit 1
fi

fichier_urls=$1

echo "<html>
	<head>
		<meta charset=\"UTF-8\">
	</head>

	<body>
		<table>
			<tr>
				<th>numero</th>
				<th>URL</th>
				<th>code</th>
				<th>encodage</th>
				<th>nombre de mots</th>
			</tr>"

lineno=1
while read -r line
do
	data=$(curl -s -i -L -w "%{http_code}\n%{content_type}" -o ./.data.tmp $line)
	http_code=$(echo "$data" | head -1)
	encoding=$(echo "$data" | tail -1 | grep -Po "charset=\S+" | cut -d"=" -f2)

	if [ -z "${encoding}" ]
	then
		encoding="N/A" # petit raccourci qu'on peut utiliser à la place du if : encoding=${encoding:-"N/A"}
	fi

	nbmots=$(cat ./.data.tmp | lynx -dump -nolist -stdin | wc -w)

	echo -e "			<tr>
				<td>$lineno</td>
				<td>$line</td>
				<td>$http_code</td>
				<td>$encoding</td>
				<td>$nbmots</td>
			</tr>"

	lineno=$(expr $lineno + 1)
done < $fichier_urls

echo "		</table>
	</body>
</html>"


rm ./.data.tmp
