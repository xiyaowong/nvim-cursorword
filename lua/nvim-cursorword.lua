local M = {}

local fn = vim.fn
local api = vim.api

function M.highlight()
  if fn.hlexists("CursorWord") == 0 or api.nvim_exec("hi CursorWord", true):find("cleared") then
    vim.cmd("hi! CursorWord cterm=underline gui=underline")
  end
end

local function matchdelete(clear_word)
  if clear_word then
    vim.w.cursorword = nil
  end
  if vim.w.cursorword_match_id then
    pcall(fn.matchdelete, vim.w.cursorword_match_id)
    vim.w.cursorword_match_id = nil
  end
end

local function matchstr(...)
  local ok, ret = pcall(fn.matchstr, ...)
  if ok then
    return ret
  end
  return ""
end

function M.matchadd()
  if vim.tbl_contains(vim.g.cursorword_disable_filetypes or {}, vim.bo.filetype) then
    return
  end

  local column = api.nvim_win_get_cursor(0)[2]
  local line = api.nvim_get_current_line()

  local left = matchstr(line:sub(1, column + 1), [[\k*$]])
  local right = matchstr(line:sub(column + 1), [[^\k*]]):sub(2)

  local cursorword = left .. right

  if cursorword == vim.w.cursorwod then
    return
  end

  vim.w.cursorword = cursorword

  matchdelete()

  if #cursorword < 3 or #cursorword > 100 or cursorword:find("[\192-\255]+") then
    return
  end

  cursorword = fn.escape(cursorword, [[~"\.^$[]*]])
  vim.w.cursorword_match_id = fn.matchadd("CursorWord", [[\<]] .. cursorword .. [[\>]], -1)
end

function M.matchdelete()
  matchdelete(true)
end

return M
