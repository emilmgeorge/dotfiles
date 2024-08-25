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
	# Ref names (decorate)       %d
	#
	#       %ad        %cd      %cr       %an       %cn           %h        %s        %d
	split(dim white " " cyan " " green " " red " " dim white " " yellow " " white " " reset, color,    " ")
	split("25 25 25 14 14 40 80 40",                                                         widths,   " ")
	split("1 1 1 1 1 0 0 0",                                                                 pad,      " ")
	split("1 1 1 1 1 0 0 0",                                                                 truncate, " ")
	split(";;;;;;;;",                                                                        prefix,   ";")
	split("  ; ;  ; ;: ; ; ;;",                                                              suffix,   ";")
	ncolumn = length(widths)
	if(!full) OFS=""
}
{
	for (i = 1; i <= NF && i <= ncolumn; ++i) {
		n = length($i)
		w = widths[i]
		if (!full) {
			if (n > w && truncate[i] == 1) {
				# Truncate field
				$i = substr($i, 1, w - 2) ".."
			}
			# Add prefix and suffix
			$i = prefix[i] $i suffix[i]
			if (n < w && pad[i] == 1) {
				# Pad field with spaces on the right
				$i = $i sprintf("%-" n - w "s", "")
			}
		}
		# Add color
		$i = color[i] $i reset
	}
	print
}
