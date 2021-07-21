if exists('g:loaded_cursorword') | finish | endif

let g:loaded_cursorword = 1

augroup CursorWord
  autocmd!
  autocmd VimEnter,ColorScheme * lua require'nvim-cursorword'.highlight()
  autocmd CursorHold,CursorHoldI * lua require'nvim-cursorword'.matchadd()
  autocmd WinLeave * lua require'nvim-cursorword'.matchdelete()
augroup END
