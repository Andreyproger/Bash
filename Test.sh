awk '{ 
	sum = 0
	for (i = 2; i <= NF; ++i) sum += $i
	if (NF > 0) print sum/(NF-1), $1
}' list.txt | sort -g -r | awk '{print $2, $1}'
