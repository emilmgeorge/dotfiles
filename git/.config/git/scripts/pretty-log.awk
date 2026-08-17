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
	color[field]       = SGR_FG_8BIT(250) # light-gray

	# Author date, Relative (%ar)
	++field
	preprocess[field]  = "preprocess_relative_date"
	width[field]       = 5
	truncate[field]    = 1
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 1
	color[field]       = SGR_FG_8BIT(242) # dark-gray

	# Committer Date (%cd)
	++field
	width[field]       = 24
	truncate[field]    = 1
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 1
	color[field]       = SGR_FG_8BIT(36) # green

	# Committer date, Relative (%cr)
	++field
	preprocess[field]  = "preprocess_relative_date"
	width[field]       = 5
	truncate[field]    = 1
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 1
	color[field]       = SGR_FG_8BIT(73) # cyan

	# Author Name (%an)
	++field
	width[field]       = 13
	truncate[field]    = 1
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 1
	color[field]       = SGR_FG_8BIT(167) # red

	# Committer Name (%cn)
	++field
	width[field]       = 13
	truncate[field]    = 1
	prefix[field]      = ""
	suffix[field]      = ":"
	pad[field]         = 1
	color[field]       = SGR_THIN SGR_FG_8BIT(188) # gray

	# short commit Hash (%h)
	++field
	width[field]       = 40
	truncate[field]    = 0
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 0
	color[field]       = SGR_THIN SGR_FG_8BIT(227) # yellow

	# svn revision (parsed from the 'git-svn-id' footer in the commit body)
	++field
	preprocess[field]  = "preprocess_svn_rev"
	width[field]       = is_svn_repo() ? 8 : 0
	maxwidth[field]    = 0 # no flex, so an absent column adds no padding
	truncate[field]    = 0
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = width[field] ? 1 : 0
	color[field]       = SGR_THIN SGR_FG_8BIT(141) # purple

	# Subject (%s)
	++field
	width[field]       = 80
	truncate[field]    = 0
	prefix[field]      = ""
	suffix[field]      = ""
	pad[field]         = 0
	color[field]       = SGR_FG_8BIT(188) # white

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
		if (!(i in maxwidth))    maxwidth[i] = 10
		if (!(i in truncate))    truncate[i] = 1
		if (!(i in prefix))      prefix[i] = ""
		if (!(i in suffix))      suffix[i] = ""
		if (!(i in align))       align[i] = 1
		if (!(i in pad))         pad[i] = 1
		if (!(i in color))       color[i] = SGR_RESET

		# Fix out of range values
		if (width[i] < 0)       width[i] = 0
		if (maxwidth[i] < 0)    maxwidth[i] = 0
		truncate[i] = !!truncate[i]
		align[i] = !!align[i]
		pad[i] = !!pad[i]
	}

	OFS=" "
}
{
	nfields = field
	if(NF < nfields)
		nfields = NF

	cumulative_flex = 0
	for (i = 1; i <= nfields; ++i) {
		if(i in preprocess) {
			preprocess_function = preprocess[i]
			$i = @preprocess_function($i)
		}
		# Do not modify or align text if 'full' option is used
		if (!full) {
			len = length($i)
			w = width[i]
			tw = w   # truncate width
			pw = w   # pad width
			flex = 0 # possible width increase based on text length
			if(w < 1) {
				tw = maxwidth[i]
				flex = tw - len
			}
			if(tw < 0)
				tw = 0
			if(pw < 0)
				pw = 0
			if(flex < 0)
				flex = 0

			# Truncate field
			if (len > tw && truncate[i] == 1) {
				$i = substr($i, 1, tw - 2) ".."
			}

			# Add prefix and suffix
			$i = prefix[i] $i suffix[i]

			# Align (left pad) column based on cumulative_flex
			if (cumulative_flex > 0 && align[i] == 1) {
				$i = sprintf("%-*s", cumulative_flex, "") $i
				cumulative_flex = 0
			}

			# Pad field with spaces on the right
			if (len < pw && pad[i] == 1) {
				$i = $i sprintf("%-*s", len - pw, "")
			}
			cumulative_flex = cumulative_flex + flex
		}
	}
	# Add color (Do this last to prevent issues with truncation, length() etc.)
	# Join the fields manually, so that empty zero-width columns (e.g. the svn
	# revision in a non-svn repository) do not emit a stray separator.
	out = ""
	for (i = 1; i <= nfields; ++i) {
		if ($i == "" && width[i] == 0 && maxwidth[i] == 0)
			continue
		out = (out == "" ? "" : out OFS) color[i] $i SGR_RESET
	}
	# Anything after the last formatted field is extra output produced by git
	# itself (e.g. `--name-status`, `--stat`, `--numstat`). Print it verbatim
	# below the commit line, so those file lists are not lost.
	rest = ""
	for (i = nfields + 1; i <= NF; ++i)
		rest = rest $i
	gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", rest)
	if (rest != "")
		out = out ORS rest
	printf "%s%s", out, ORS
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

# Returns 1 if the current repository is managed by git-svn, 0 otherwise.
# The result is cached, since this is only needed once per run.
function is_svn_repo(   cmd, line, result) {
	if (IS_SVN_REPO != "")
		return IS_SVN_REPO - 1

	result = 0
	cmd = "git config --get svn-remote.svn.url 2>/dev/null"
	if ((cmd | getline line) > 0 && line != "")
		result = 1
	close(cmd)

	IS_SVN_REPO = result + 1 # store as 1/2 so "" means 'not yet resolved'
	return result
}

# Returns the svn repository UUID, or "" if unknown.
# The result is cached, since this is only needed once per run.
function svn_uuid(   cmd, line) {
	if (SVN_UUID != "")
		return SVN_UUID == "-" ? "" : SVN_UUID

	SVN_UUID = "-"
	cmd = "git config --get svn-remote.svn.uuid 2>/dev/null"
	if ((cmd | getline line) > 0 && line != "")
		SVN_UUID = line
	close(cmd)

	return SVN_UUID == "-" ? "" : SVN_UUID
}

# Extracts the svn revision from the 'git-svn-id' footer of a commit body.
# The footer looks like: `git-svn-id: <repository path>@<revision> <UUID>`
# If several footers are present, the last one is used.
function preprocess_svn_rev(body, uuid, pattern, m, rev) {
	if (!is_svn_repo() || body == "")
		return ""

	uuid = svn_uuid()
	pattern = "git-svn-id:[^@]*@([0-9]+)[ \t]+" (uuid == "" ? "[0-9a-fA-F-]+" : uuid)

	rev = ""
	while (match(body, pattern, m)) {
		rev = m[1]
		body = substr(body, RSTART + RLENGTH)
	}

	return rev == "" ? "" : "r" rev
}

function preprocess_ref_names(refnames) {
	# Add brackets around ref names (like %d, but without the leading space)
	if(refnames != "")
		refnames = SGR_FG_YELLOW "(" SGR_RESET refnames SGR_FG_YELLOW ")" SGR_RESET
	return refnames
}
