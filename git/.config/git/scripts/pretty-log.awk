#!/bin/awk
# Based on https://www.reddit.com/r/bash/comments/cid27d/

BEGIN {
	reset  = "\033[m"
	dim    = "\033[2m"
	white  = "\033[37m"
	cyan   = "\033[36m"
	green  = "\033[32m"
	red    = "\033[31m"
	yellow = "\033[33m"

	# Author date                %an
	# Committer date             %cn
	# Committer relative date    %cr
	# Author name                %an
	# Committer name             %cn
	# Hash                       %h
	# Subject                    %s
	# Ref names (decorate)       %D
	#
	#        %ad        %cd      %cr       %an       %cn           %h        %s        %D
	split(dim white " " cyan " " green " " red " " dim white " " yellow " " white " " reset, color,    " ")
	split("24 24 24 13 13 40 80 40",                                                         widths,   " ")
	split("1 1 1 1 1 0 0 0",                                                                 pad,      " ")
	split("1 1 1 1 1 0 0 0",                                                                 truncate, " ")
	split(";;;;;;;",                                                                         prefix,   ";")
	split(";;;;:;;;",                                                                        suffix,   ";")
	OFS=" "
}
{
	# Add brackets around ref names (like %d, but without the leading space)
	if($8 != "")
		$8 = yellow "(" reset $8 yellow ")" reset

	ncolumn = length(widths)
	if(NF < ncolumn)
		ncolumn = NF
	for (i = 1; i <= ncolumn; ++i) {
		# Do not modify/align text if 'full' option is used
		if (!full) {
			n = length($i)
			w = widths[i]
			if (n > w && truncate[i] == 1) {
				# Truncate field
				$i = substr($i, 1, w - 2) ".."
			}
			# Add prefix and suffix
			$i = prefix[i] $i suffix[i]
			if (n < w && pad[i] == 1) {
				# Pad field with spaces on the right
				$i = $i sprintf("%-*s", n - w, "")
			}
		}
		# Add color
		$i = color[i] $i reset
	}
	printf "%s", $0
}
