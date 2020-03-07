" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

""""""""""""""""""""" BEGIN CUSTOM KEY MAPPING """"""""""""""""""""""""

" Leader key
let mapleader=" "

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Use space to insert single char and return to normal mode
nnoremap <leader><space> i<space><Esc>r

" Formatting
map <leader>q gqip

" Yank to system primary / clipboard
nnoremap <leader>Y "+y
nnoremap <leader>p "+p
nnoremap <leader>y "*y
nnoremap <leader>P "*p

" Buffer navigation
" nnoremap <C-n> :bn<CR> " Used by Yankring
" nnoremap <C-p> :bp<CR> " Used by Yankring
nnoremap <leader>1 :buffer 1<CR>
nnoremap <leader>2 :buffer 2<CR>
nnoremap <leader>3 :buffer 3<CR>
nnoremap <leader>4 :buffer 4<CR>
nnoremap <leader>5 :buffer 5<CR>
nnoremap <leader>6 :buffer 6<CR>
nnoremap <leader>7 :buffer 7<CR>
nnoremap <leader>8 :buffer 8<CR>
nnoremap <leader>9 :buffer 9<CR>

" clear search
map <silent> <leader>c :let @/=''<cr>

" Start the find and replace command for last selected (visual) text
" https://stackoverflow.com/a/6171215
map <leader>h <Esc>:%s/<c-r>=GetVisual()<cr>//gc<Left><Left><Left>

" Do not jump to next match when pressing asterisk
" https://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump
nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr>

" Visualize whitespace characters
" See listchars option below
map <leader>l :set list!<CR>

""""""""""""""" Plugin Keymaps """""""""""""""

" fzf
inoremap <C-f> <ESC>:Files<CR>
inoremap <C-g> <ESC>:GFiles<CR>
inoremap <C-j> <ESC>:Buffers<CR>
inoremap <C-l> <ESC>:Lines<CR>
noremap <C-f> :Files<CR>
noremap <C-g> :GFiles<CR>
noremap <C-j> :Buffers<CR>
noremap <C-l> :Lines<CR>

" NERDTree toggle
inoremap <C-c> <ESC>:call NERDTreeToggleInCurDir()<CR>
noremap <C-c> :call NERDTreeToggleInCurDir()<CR>

" Undotree
nnoremap <F7> :UndotreeToggle<cr>

" Tagbar plugin
nnoremap <F8> :TagbarToggle<CR>

" Yankring Plugin shortcut
nnoremap <F9> :YRShow<CR>

" Toggle Syntastic
map <F10> <ESC>:call SyntasticToggle()<CR>

""""""""""""""""""""" END CUSTOM KEY MAPPING """"""""""""""""""""""""""

""""""""""""""""""""" BEGIN PLUGINS: vim-plug """""""""""""""""""""""""

" Install vim-plug if already not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
" Syntax:
" Plug '<github-username>/<reponame>'
" Plug 'https://gist.github.com/xxxxxxxxxx.git',
"    \ { 'as': 'xxx', 'do': 'mkdir -p plugin; cp -f *.vim plugin/' }

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'srcery-colors/srcery-vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tomtom/tcomment_vim'
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'mattn/emmet-vim'
Plug 'vim-scripts/rename.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-scripts/YankRing.vim'
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'mbbill/undotree'

Plug 'kana/vim-textobj-user'
Plug 'adriaanzon/vim-textobj-matchit'
Plug 'sgur/vim-textobj-parameter'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Auto load cscope DB in CCTree
autocmd VimEnter * if filereadable('cscope.out') | exec "CCTreeLoadDB 'cscope.out'" | endif


"""""""""""""""""""""""" BEGIN PLUGIN CONFIG """"""""""""""""""""""""""

" Ctags config
let g:ctags_statusline = 1
let g:generate_tags = 1

" Airline
let g:airline_theme='minimalist'
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#bufferline#overwrite_variables = 1
let g:airline_extensions = ['branch', 'bufferline', 'tagbar']
let g:bufferline_echo = 0

" NERDTree Config
let g:NERDTreeQuitOnOpen=1

" Close NERDTree ( and vim) when last file is closed
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")
            \ && b:NERDTree.isTabTree()) | q | endif

" NERDTree Git custom symbols
let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "-",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "*",
            \ "Clean"     : "✔︎",
            \ 'Ignored'   : '☒',
            \ "Unknown"   : "?"
            \ }


" start of default statusline
set statusline=%f\ %h%w%m%r\

" Syntastic statusline
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" " end of default statusline (with ruler)
set statusline+=%=%(%l,%c%V\ %=\ %P%)

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height=5
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_auto_jump = 0
let g:syntastic_c_include_dirs = [ '../include', 'include', '../inc', 'inc' ]
let g:syntastic_c_config_file = './.vim/c_config'
let g:syntastic_cpp_include_dirs = [ '../include', 'include', '../inc', 'inc' ]
let g:syntastic_cpp_config_file = './.vim/cpp_config'

" State variable for SyntasticToggle() function below
let g:syntastic_is_open = 0

" Emmet config
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
let g:user_emmet_leader_key='<C-t>'

" Multi cursor
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-k>' " default: C-x
let g:multi_cursor_quit_key            = '<Esc>'

" Yank ring config
let g:yankring_replace_n_pkey = ''
let g:yankring_replace_n_nkey = ''

"""""""""""""""""""""""" END PLUGIN CONFIG """"""""""""""""""""""""""""

""""""""""""""""""""""""""" END PLUGINS """""""""""""""""""""""""""""""

" For plugins to load correctly
filetype plugin indent on

" Turn on syntax highlighting
syntax on

" Theme
colorscheme srcery
set t_Co=256
set background=dark

" Transparent BG
hi Normal guibg=NONE ctermbg=NONE

" highlight current substitution in different color
hi IncSearch ctermbg=red ctermfg=black

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Security
set modelines=0

" Show line numbers relative to current line
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Show file stats
set ruler

" Recursive file finding
set path+=**

" Wildmenu
set wildmenu
set wildmode=list:longest,full

" Blink cursor on error instead of beeping (grr)
set visualbell

" Keep cursor away from top/bottom when scrolling
set scrolloff=5

" Allow normal backspacing
set backspace=indent,eol,start

" Match pairs using %
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Status bar
set laststatus=2

" Show partial command on last line
set showcmd

" Dont show mode on last line
set noshowmode

" Highlight current line
set cul
hi CursorLine term=none cterm=none ctermbg=235

" Allow moving to one char position beyond last char in a line
set virtualedit=onemore

" Show matching paranthesis
set showmatch

" Search settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" Encoding
set encoding=utf-8

" Indent settings
set tabstop=4     "- tabs are these many characters
set softtabstop=4 "- Pressing tab key inserts these many characters
set shiftwidth=4  "- indenting (eg. > and < operations)
set shiftround    "- Round to 'shiftwidth' chars
set autoindent    "- turns it on
set cindent       "- stricter rules for C programs

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1

" Split below and right by default
set splitbelow
set splitright

" Enable Syntax Code Folding (makes vim slow on large files)
set foldmethod=syntax
set foldnestmax=10
set nofoldenable
set foldlevel=10

" Whitespace characters
if has("patch-7.4.710")
	set listchars=tab:│\ ,extends:›,precedes:‹,nbsp:·,trail:·,space:·
else
	set listchars=tab:│\ ,extends:›,precedes:‹,nbsp:·,trail:·
endif

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
" Show trailing whitespace:
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
\ if line("'\"") >= 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"""""""""""""""""""""""""" BEGIN FUNCTIONS """"""""""""""""""""""""""""

""""""""""""""""""""""""""" EscapeString() """"""""""""""""""""""""""""
" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

"""""""""""""""""""""""""""" GetVisual() """"""""""""""""""""""""""""""
" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this:
" https://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

  "Escape any special characters in the selection
  let escaped_selection = EscapeString(selection)

  return escaped_selection
endfunction

"""""""""""""""""""""""" SyntasticToggle() """"""""""""""""""""""""""""
function! SyntasticToggle()
    if g:syntastic_is_open == 1
        lclose
        let g:syntastic_is_open = 0
    else
        Errors
        let g:syntastic_is_open = 1
    endif
endfunction

""""""""""""""""""""" NERDTreeToggleInCurDir() """"""""""""""""""""""""
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    if (expand("%:t") != '')
      exe ":NERDTreeFind"
    else
      exe ":NERDTreeToggle"
    endif
  endif
endfunction

"""""""""""""""""""""""""" END FUNCTIONS """"""""""""""""""""""""""""""
