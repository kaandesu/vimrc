let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"
set path +=**

set nocompatible

set relativenumber
set ts=4 sw=4

syntax enable
filetype plugin on

if executable('gopls')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'allowlist': ['go'],
        \ })
endif

" Helper to organize imports via gopls
function! s:go_organize_imports() abort
  let actions = lsp#utils#code_action_sync([], ['source.organizeImports'], 1000)
  for action in actions
    call lsp#utils#execute_command(action)
  endfor
endfunction

" Called whenever LSP attaches to a buffer
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> K  <plug>(lsp-hover)
  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

  let g:lsp_format_sync_timeout = 1000

  " organize imports, then format, on each Go write
  autocmd! BufWritePre <buffer> *.go call s:go_organize_imports()
  autocmd  BufWritePre <buffer> *.go call LspDocumentFormatSync()
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
