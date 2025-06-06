let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"
set path +=**

set nocompatible

if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

set relativenumber
set ts=4 sw=4

set mouse=a
let mapleader = " "
syntax enable

"-------------------------------------------------------
nmap <leader>e :Vexplore<CR>
" Set Netrw to open in a vertical split
let g:netrw_winsize = 18
" Hide some unnecessary details in Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
"-------------------------------------------------------

"-------------------------------------------------------
nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
autocmd VimEnter * nnoremap <C-j> :LspNextDiagnostic<CR>

" nnoremap <C-j> :LspNextDiagnostic<CR>
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap sv :vsplit <Cr>
nnoremap ss :split <Cr>

nnoremap <leader>wd :q <Cr>


nnoremap n nzz
nnoremap N Nzz


nnoremap ğ }zz
nnoremap ü {zz
nnoremap { }zz
nnoremap } {zz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

nnoremap + <C-a>
nnoremap - <C-x>
nnoremap <C-A> ggVG

" disable auto comment in new line
set formatoptions-=r

" <Saving>
cabbrev W w
cabbrev Wq wq
cabbrev WQ wq
" </Saving>

"--------<VIM-GUTGUTTER>--------------
" Optional: Customize signs (you can skip if defaults are fine)
let g:gitgutter_sign_added = '█'
let g:gitgutter_sign_modified = '█|'
let g:gitgutter_sign_removed = '█'
let g:gitgutter_sign_modified_removed = '█'

highlight GitGutterAdd    guifg=#00ff00 ctermfg=Green
highlight GitGutterChange guifg=#ffff00 ctermfg=Blue
highlight GitGutterDelete guifg=#ff0000 ctermfg=Red

set updatetime=250
nmap <Leader>gn :GitGutterNextHunk<CR>  
nmap <Leader>gp :GitGutterPrevHunk<CR> 
nmap <Leader>gha :GitGutterStageHunk<CR>
nmap <Leader>ghr :GitGutterUndoHunk<CR>

let g:gitgutter_highlight_lines = 0
let g:gitgutter_hunk_previewed = 0
let g:gitgutter_preview_line = -1

" only preview when im on the line that i opened it
" close it if i move
function! PreviewHunk()
  if g:gitgutter_hunk_previewed == 1
    let g:gitgutter_hunk_previewed = 0
    let g:gitgutter_preview_line = -1
  else
    GitGutterPreviewHunk
    let g:gitgutter_hunk_previewed = 1
    let g:gitgutter_preview_line = line('.')
  endif
endfunction

nnoremap <Leader>ghp :call PreviewHunk()<CR>

augroup GitGutterAutoClosePreview
  autocmd!
  autocmd CursorMoved * if g:gitgutter_hunk_previewed == 1 && line('.') != g:gitgutter_preview_line | pclose | let g:gitgutter_hunk_previewed = 0 | let g:gitgutter_preview_line = -1 | endif
augroup END
"--------</VIM-GUTGUTTER>--------------

"--------TODO:-------- ADD CONFIG FOR VIM-SURROUND--------------
" probably <C-g> or i need to think about with glove80 in mind
" <C-g> was a good idea for a while but i don't know

"-------<VIM-TARGET>--------------
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr rr rb rB bb bB BB'
"--------</VIM-TARGET>--------------

"----------------some vim settings----------------------------
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set belloff=all
set breakindent
set complete=.,w,b,u,t
set completeopt=menuone,longest,preview
set expandtab
set fillchars=vert:│,fold:-,eob:~,lastline:@
set grepformat=%f:%l:%c:%m,%f:%l:%m
set hidden
set hlsearch
set ignorecase
set incsearch
set infercase
set iskeyword=@,48-57,_,192-255,-,#
set laststatus=2
set lazyredraw
set nocompatible
set nofoldenable
set noswapfile
set nowrap
set number
set pumheight=50
set scrolloff=0
set shiftwidth=4
set shortmess=flnxtocTOCI
set showmode
set signcolumn=yes
set smartcase
set smarttab
set softtabstop=4
set tabstop=4
" set termguicolors
set textwidth=100
set ttimeout
set ttimeoutlen=100
set ttyfast
set undodir=expand('$HOME/.vim/undo/')
set undofile
set viminfofile=$HOME/.vim/.viminfo
set wildignorecase
set wildmenu
set wildoptions=pum
set wrapscan
" After adding the fugitive
"set statusline=%f:%l:%c\ %m%r%h%w%q%y%{FugitiveStatusline()}
"-------------------------------------------------------
	
filetype plugin on
set clipboard^=unnamed,unnamedplus

if executable('gopls')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'allowlist': ['go'],
        \ })
endif


function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> K  <plug>(lsp-hover)
  " nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  " nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
  " nmap <buffer> <Leader><Leader> <plug>(lsp-code-action)
  " nmap <buffer> <Leader>ro :LspCodeAction source.organizeImports<CR>

  let g:lsp_format_sync_timeout = 1000
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" autocomplete https://github.com/prabirshrestha/asyncomplete.vim
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1


augroup go_lsp_on_save
  autocmd!
  autocmd BufWritePre *.go :LspCodeAction source.organizeImports
  autocmd BufWritePre *.go :LspDocumentFormatSync
augroup END
