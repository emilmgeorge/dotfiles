# Awk GNU(gawk) features used:
#   - Indirect Function Calls (preprocess_function)

BEGIN {
	define_sgr_codes()

	# Field counter
	field = 0

	# Author Date (%ad)
	++field
	width[field]       = 24
	truncate[field]    = 1
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 1
	color[field]       = SGR_THIN SGR_FG_WHITE

	# Committer Date (%cd)
	++field
	width[field]       = 24
	truncate[field]    = 1
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 1
	color[field]       = SGR_FG_CYAN

	# Committer date, Relative (%cr)
	++field
	preprocess[field]  = "preprocess_relative_date"
	width[field]       = 5
	truncate[field]    = 1
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 1
	color[field]       = SGR_FG_GREEN

	# Author Name (%an)
	++field
	width[field]       = 13
	truncate[field]    = 1
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 1
	color[field]       = SGR_FG_RED

	# Committer Name (%cn)
	++field
	width[field]       = 13
	truncate[field]    = 1
	prefix[field]      = ""
	suffix[field]      = ":"
	pad[field]         = 1
	color[field]       = SGR_THIN SGR_FG_WHITE

	# short commit Hash (%h)
	++field
	width[field]       = 40
	truncate[field]    = 0
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 0
	color[field]       = SGR_FG_YELLOW

	# Subject (%s)
	++field
	width[field]       = 80
	truncate[field]    = 0
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 0
	color[field]       = SGR_FG_WHITE

	# ref names as in --decorate (%d)
	++field
	preprocess[field]  = "preprocess_ref_names"
	width[field]       = 40
	truncate[field]    = 0
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 0
	color[field]       = SGR_RESET

	for (i = 1; i <= field; ++i) {
		# Default values
		if (!(i in width))       width[i] = 10
		if (!(i in truncate))    truncate[i] = 1
		if (!(i in prefix))      prefix[i] = ""
		if (!(i in suffix))      suffix[i] = ""
		if (!(i in pad))         pad[i] = 1
		if (!(i in color))       color[i] = SGR_RESET

		# Fix out of range values
		if (width[i] < 0)       width[i] = 0
		truncate[i] = !!truncate[i]
		pad[i] = !!pad[i]
	}

	OFS=" "
}
{
	nfields = field
	if(NF < nfields)
		nfields = NF
	for (i = 1; i <= nfields; ++i) {
		if(i in preprocess) {
			preprocess_function = preprocess[i]
			$i = @preprocess_function($i)
		}
		# Do not modify or align text if 'full' option is used
		if (!full) {
			len = length($i)
			w = width[i]

			# Truncate field
			if (len > w && truncate[i] == 1) {
				$i = substr($i, 1, w - 2) ".."
			}

			# Add prefix and suffix
			$i = prefix[i] $i suffix[i]

			# Align (left pad) column based on cumulative_flex
			if (len < w && pad[i] == 1) {
				$i = $i sprintf("%-*s", len - w, "")
			}
		}
	}
	# Add color (Do this last to prevent issues with truncation, length() etc.)
	for (i = 1; i <= nfields; ++i) {
		$i = color[i] $i SGR_RESET
	}
	printf "%s", $0
}

function define_sgr_codes() {
	# Reset
	SGR_RESET               = "\033[m"

	# Enable effect
	SGR_BOLD                = "\033[1m"
	SGR_THIN                = "\033[2m"
	SGR_ITALIC              = "\033[3m"
	SGR_UNDERLINE           = "\033[4m"
	SGR_BLINK               = "\033[5m"
	SGR_RAPIDBLINK          = "\033[6m"
	SGR_INVERSE             = "\033[7m"
	SGR_CONCEAL             = "\033[8m"
	SGR_STRIKE              = "\033[9m"
	# not used (fonts)      - "\033[10m" to "\033[20m"
	SGR_DOUBLE_UNDERLINE    = "\033[21m"

	# Disable effect
	SGR_BOLD_THIN_OFF       = "\033[22m"
	SGR_ITALIC_OFF          = "\033[23m"
	SGR_UNDERLINE_OFF       = "\033[24m"
	SGR_BLINK_OFF           = "\033[25m"
	# not used              - "\033[26m"
	SGR_INVERSE_OFF         = "\033[27m"
	SGR_CONCEAL_OFF         = "\033[28m"
	SGR_STRIKE_OFF          = "\033[29m"

	# FG colors
	SGR_FG_BLACK            = "\033[30m"
	SGR_FG_RED              = "\033[31m"
	SGR_FG_GREEN            = "\033[32m"
	SGR_FG_YELLOW           = "\033[33m"
	SGR_FG_BLUE             = "\033[34m"
	SGR_FG_MAGENTA          = "\033[35m"
	SGR_FG_CYAN             = "\033[36m"
	SGR_FG_WHITE            = "\033[37m"

	SGR_FG_RESET            = "\033[39m" # reset fg

	SGR_FG_BRIGHT_BLACK     = "\033[90m"
	SGR_FG_BRIGHT_RED       = "\033[91m"
	SGR_FG_BRIGHT_GREEN     = "\033[92m"
	SGR_FG_BRIGHT_YELLOW    = "\033[93m"
	SGR_FG_BRIGHT_BLUE      = "\033[94m"
	SGR_FG_BRIGHT_MAGENTA   = "\033[95m"
	SGR_FG_BRIGHT_CYAN      = "\033[96m"
	SGR_FG_BRIGHT_WHITE     = "\033[97m"
	# See functions below for more FG colors

	# BG colors
	SGR_BG_BLACK            = "\033[40m"
	SGR_BG_RED              = "\033[41m"
	SGR_BG_GREEN            = "\033[42m"
	SGR_BG_YELLOW           = "\033[43m"
	SGR_BG_BLUE             = "\033[44m"
	SGR_BG_MAGENTA          = "\033[45m"
	SGR_BG_CYAN             = "\033[46m"
	SGR_BG_WHITE            = "\033[47m"

	SGR_BG_RESET            = "\033[49m" # reset bg

	SGR_BG_BRIGHT_BLACK     = "\033[100m"
	SGR_BG_BRIGHT_RED       = "\033[101m"
	SGR_BG_BRIGHT_GREEN     = "\033[102m"
	SGR_BG_BRIGHT_YELLOW    = "\033[103m"
	SGR_BG_BRIGHT_BLUE      = "\033[104m"
	SGR_BG_BRIGHT_MAGENTA   = "\033[105m"
	SGR_BG_BRIGHT_CYAN      = "\033[106m"
	SGR_BG_BRIGHT_WHITE     = "\033[107m"
	# See functions below for more FG colors
}

# https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
function SGR_FG_8BIT(color) {
	return "\033[38;5;" color "m"
}
function SGR_BG_8BIT(color) {
	return "\033[48;5;" color "m"
}

# https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit
function SGR_FG_24BIT(r, g, b) {
	return "\033[38;2;" r ";" g ";" b "m"
}
function SGR_BG_24BIT(color) {
	return "\033[48;2;" r ";" g ";" b "m"
}

function preprocess_relative_date(date) {
	gsub(/years?/, "y", date)
	gsub(/months?/, "M", date)
	gsub(/weeks?/, "w", date)
	gsub(/days?/, "d", date)
	gsub(/hours?/, "h", date)
	gsub(/minutes?/, "m", date)
	gsub(/seconds?/, "s", date)
	gsub(/ ago/, "", date)
	gsub(/,/, "", date)
	gsub(/ /, "", date)
	return date
}

function preprocess_ref_names(refnames) {
	# Add brackets around ref names (like %d, but without the leading space)
	if(refnames != "")
		refnames = SGR_FG_YELLOW "(" SGR_RESET refnames SGR_FG_YELLOW ")" SGR_RESET
	return refnames
}
