if exists('g:loaded_cursorword') | finish | endif

if !has('nvim')
    echohl Error
    echom "Sorry this plugin only works with versions of neovim that support lua"
    echohl clear
    finish
endif

let g:loaded_cursorword = 1

augroup CursorWord
  autocmd!
  autocmd VimEnter,ColorScheme * lua require('nvim-cursorword').highlight()
  autocmd CursorMoved,CursorMovedI * lua require('nvim-cursorword').matchadd()
  autocmd WinLeave * lua require('nvim-cursorword').matchdelete()
augroup END
