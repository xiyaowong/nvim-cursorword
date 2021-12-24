# nvim-cursorword

Part of [nvim-cursorline](https://github.com/yamatsum/nvim-cursorline).

![screenshot](https://user-images.githubusercontent.com/47070852/124384896-02b6aa80-dd06-11eb-8a44-dfd142acdada.gif)

## feature

Only highlight the word under the cursor.

## Option

disable highlighting for some filetypes

```vimscript
let g:cursorword_disable_filetypes = []
```

or

```lua
vim.g.cursorword_disable_filetypes = {}
```

## highlight

by default

```viml
hi! CursorWord cterm=underline gui=underline
```
