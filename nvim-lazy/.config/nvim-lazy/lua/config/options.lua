-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable LazyVim auto-format on save
vim.g.autoformat = false

-- Disable auto-write on buffer switch
vim.opt.autowrite = false

-- Setting this reduces the chance of key sequences like <Esc>j being
-- interpreted as ANSI escape sequences like ^[j, rather than as two separate
-- key presses (<Esc> and j). ANSI escape sequences can still be triggered
-- manually using Alt+key (e.g., <Alt-j> for ^[j). Without this, pressing <Esc>
-- followed by a key may unintentionally trigger the corresponding Alt+key
-- binding.
-- Note 1: Setting [ttimeout = false] or [ttimeoutlen = -1] can cause input
--         issues when opening Neovim. See details here:
--         https://github.com/neovim/neovim/issues/29047
--         https://github.com/neovim/neovim/issues/33148
-- Note 2: <Alt-*> bindings may still be triggered in some cases, especially
--         during remote sessions.
vim.o.ttimeoutlen = 0

-- Allow moving to one char position beyond last char in a line
vim.opt.virtualedit = "onemore"

-- Whitespace display
vim.opt.listchars = "eol:⬎,tab:│─,space:˽,extends:→,precedes:←,nbsp:⍽"
vim.opt.list = false

-- Formatting options
vim.opt.wrap = true
vim.opt.textwidth = 80
vim.opt.colorcolumn = "80"
vim.opt.formatoptions = "crqn2l1j"
vim.opt.cinoptions = ":0,l1,g0,t0,(0"

-- Set format for fold text
vim.cmd([[
function! GetSpaces(foldLevel)
    if &expandtab == 1
        " Indenting with spaces
        let str = repeat(" ", a:foldLevel / (&shiftwidth + 1) - 1)
        return str
    elseif &expandtab == 0
        " Indenting with tabs
        return repeat(" ", indent(v:foldstart) - (indent(v:foldstart) / &shiftwidth))
    endif
endfunction

function! MyFoldText()
    let startLineText = getline(v:foldstart)
    let secondLineText = trim(getline(v:foldstart + 1))
    let endLineText = trim(getline(v:foldend))
	let linecount = v:foldend - v:foldstart - 1
    let indentation = GetSpaces(foldlevel("."))
    let end = repeat("-", 200)

	if secondLineText != "{"
		let secondLineText = ""
	else
		let secondLineText = " " . secondLineText
	endif

    let str = indentation . startLineText . secondLineText . " ... " . endLineText . " [" . linecount . " lines] " . end

    return str
endfunction

" Custom display for text when folding
set foldtext=MyFoldText()
]])
