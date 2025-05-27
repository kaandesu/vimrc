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

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> K  <plug>(lsp-hover)
  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

  nmap <buffer> <Leader><Leader> <plug>(lsp-code-action)
  nmap <buffer> <Leader>ro :LspCodeAction source.organizeImports<CR>

  let g:lsp_format_sync_timeout = 1000
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

augroup go_lsp_on_save
  autocmd!
  autocmd BufWritePre *.go :LspCodeAction source.organizeImports
  autocmd BufWritePre *.go :LspDocumentFormatSync
augroup END
