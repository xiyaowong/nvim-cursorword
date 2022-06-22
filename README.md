# nvim-cursorword

Part of [nvim-cursorline](https://github.com/yamatsum/nvim-cursorline).

![screenshot](https://user-images.githubusercontent.com/47070852/124384896-02b6aa80-dd06-11eb-8a44-dfd142acdada.gif)

## feature

Only highlight the word under the cursor.

## Options



```vim
" disable highlighting for some filetypes
let g:cursorword_disable_filetypes = []

" disable highlighting at startup.
" run :CursorWordEnable or :CursorWordToggle to activate highlighting
let g:cursorword_disable_at_startup = v:true

" min width of word
let g:cursorword_min_width = 3

" max width of word
let g:cursorword_max_width = 50
```

## Commands


```vimscript
:CursorWordDisable
:CursorWordEnable
:CursorWordToggle
```


## highlight

by default

```viml
hi default CursorWord cterm=underline gui=underline
```
