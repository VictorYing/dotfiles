set nocompatible

" PER-DIRECTORY .vimrc
set exrc
set secure

" But no per-file modelines.
set modelines=0


" AVOID DATA LOSS

" Keep undo information in *.un~ files
set undofile

" Enable undo of deletion actions in insert mode
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Remember more command-line history
set history=1000

if !has('nvim')
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "1000:  will save up to 1000 lines for each register
"  :1000:  command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo=!,'10,\"1000,:1000,%,n~/.viminfo
endif

" If file is changed outside of vim and not changed inside of vim,
" automatically update vim buffer contents to match new file contents.
" You can undo with 'u'.
" NOTE: This won't work in tmux unless you configure tmux to pass through focus events
set autoread

set tabpagemax=50

set sessionoptions-=options
set viewoptions-=options


" TEXT
set encoding=utf-8


" FORMATTING

set autoindent

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Use filetype detection and file-based automatic indenting.
    filetype plugin indent on

    " Set some filetypes to get better formatting and syntax highlighting
    autocmd BufNewFile,BufRead SCons* set filetype=scons
    " For working with git-revise (https://github.com/mystor/git-revise)
    autocmd BufRead,BufNewFile COMMIT_EDITMSG set filetype=gitcommit
    " I don't use Modula-2.  Only needed for old versions of Vim.  See:
    " https://github.com/vim/vim/commit/7d76c804af900ba6dcc4b1e45373ccab3418c6b2#diff-c07c0771a9f5af08e375703487a8fe7bbddd71f98a7bbe06acd78365525a243eR1246
    autocmd BufNewFile,BufRead *.md set filetype=markdown
    " I don't use Smalltalk.  Needed for (La)TeX .cls files that don't start
    " with a comment.  See:
    " https://github.com/vim/vim/blob/50157ef1c2e36d8696e79fd688bdd08312196bc6/runtime/filetype.vim#L1624
    autocmd BufNewFile,BufRead *.cls set filetype=tex

    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab

    " clang-format
    if has('python')
        autocmd FileType c,cpp map <C-I> :pyf ~/.vim/clang-format.py<CR>
    elseif has('python3')
        autocmd FileType c,cpp map <C-I> :py3f ~/.vim/clang-format.py<CR>
    endif

    " https://stackoverflow.com/q/28078407
    autocmd Filetype c,cpp set comments^=:///
endif

" For everything else, use a tab width of 2 space chars.
set tabstop=8       " Display TAB as having width 8.
set shiftwidth=2    " Indent width.
set softtabstop=2   " Sets the number of columns for a TAB.
set expandtab       " Expand TABs to spaces.
set smarttab

" Delete comment leaders when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif


" HIGHLIGHTING

" turn on syntax highlighting
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif
colorscheme elflord
"set t_Co=16

if exists('+colorcolumn')
  " highlight 80th column
  set colorcolumn=80
else
  " highlight columns after 80
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" highlight trailing whitespace
" This is much louder than the use of 'trail' in 'listchars' below.
"match ErrorMsg '\s\+$'

" Turn on spell checking for some filetypes
autocmd FileType gitcommit setlocal spell
autocmd FileType tex,plaintex,context setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType text setlocal spell
set spellfile=~/.vim/spell/en.utf-8.add

" Reduce slowness with long lines
if &synmaxcol == 3000
  set synmaxcol=500
endif


" DISPLAY & INFORMATION

set ttyfast

" Do *not* disable beeping.  Attempting to flash screen depending on t_vb is
" unreliable.  Instead, enforce the default that bells send \a to the
" terminal.  I leave it to my terminal to decide whether to actually play an
" audible sound.  In Windows Terminal, for example, I set `Settings > Profiles
" > Defaults > Advanced > Bell notification style` to "Flash window"
set novisualbell
" normal-mode errors that display error messages should also 'ring the bell'
set errorbells
" N.B. Nvim has 'belloff' which is enabled by default.

" Always show status bar
set laststatus=2

" leave last command visible
set showcmd

" show line numbers
set number
set relativenumber

" turn on line and column number in status bar
set ruler

" Show as much as possible of line that wraps past end of window
set display+=lastline
" Nvim also has msgsep, included by default

" Keep context lines visible around cursor
set scrolloff=3

" Smooth sideways scrolling (when nowrap is set)
set sidescroll=1
" Keep context columns visible around cursor
set sidescrolloff=5

" Show potentially unwanted whitespace and line wraps
set list listchars=tab:▸\ ,trail:·,nbsp:·,precedes:←,extends:→


" MOTION

" Unbind the arrow keys in insert, normal and visual modes.
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

" Move in display lines, not physical lines
nnoremap j gj
nnoremap k gk

" Make '%' understand if/else etc. in many languages
" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif


" SEARCHING

set incsearch
set hlsearch
nnoremap <C-n> :noh<cr>

" case insensitive, unless search pattern includes capital letter
set ignorecase
set smartcase

" invert meaning of 'g' flag: search for multiple matches in a line
set gdefault

" Semicolon means search upward in directory tree to find tags file
" See `:help file-searching`
set tags=./tags;


" EDITING

" make backspace work
set backspace=indent,eol,start

" Reduce noise from headers in insert-mode autocomplete
set complete-=i

" Sensible command autocomplete
set wildmenu
set wildmode=list:longest
set wildoptions+=tagfile
" Specific to Nvim? Nvim default:
"set wildoptions+=pug

" Increment/decrement decimal numbers with leading zero
set nrformats-=octal

" https://stackoverflow.com/a/18730056
xnoremap <expr> P '"_d"'.v:register.'P'

" CUSTOM KEYBINDINGS

inoremap jj <Esc>

" Timeout for above multi-keypress bindings
set timeoutlen=200
" Key codes should use a shorter timeout
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=50
endif
