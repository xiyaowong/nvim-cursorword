if exists('g:loaded_cursorword') | finish | endif

let g:loaded_cursorword = 1

hi default CursorWord cterm=underline gui=underline

augroup CursorWord
  autocmd!
  autocmd CursorMoved,CursorMovedI * lua require'nvim-cursorword'.matchadd()
  autocmd WinLeave * lua require'nvim-cursorword'.matchdelete()
augroup END
