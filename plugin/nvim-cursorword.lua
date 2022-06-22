if vim.g.loaded_cursorword then
  return
end
vim.g.loaded_cursorword = true

local fn = vim.fn
local api = vim.api

------ core functions -------

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
  return ok and ret or ""
end

local function matchadd()
  if vim.tbl_contains(vim.g.cursorword_disable_filetypes or {}, vim.bo.filetype) then
    return
  end

  local column = api.nvim_win_get_cursor(0)[2]
  local line = api.nvim_get_current_line()

  local left = matchstr(line:sub(1, column + 1), [[\k*$]])
  local right = matchstr(line:sub(column + 1), [[^\k*]]):sub(2)

  local cursorword = left .. right

  if cursorword == vim.w.cursorword then
    return
  end

  vim.w.cursorword = cursorword

  matchdelete()

  if
    #cursorword < (vim.g.cursorword_min_width or 3)
    or #cursorword > (vim.g.cursorword_max_width or 50)
    or cursorword:find("[\192-\255]+")
  then
    return
  end

  cursorword = fn.escape(cursorword, [[~"\.^$[]*]])
  vim.w.cursorword_match_id = fn.matchadd("CursorWord", [[\<]] .. cursorword .. [[\>]], -1)
end

local function set_highlight()
  api.nvim_set_hl(0, "CursorWord", { underline = 1, default = 1 })
end

------ setup ------

local group_id
local enabled

local function set_autocmds()
  enabled = true
  group_id = api.nvim_create_augroup("CursorWord", { clear = true })
  api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = group_id,
    pattern = "*",
    callback = matchadd,
  })
  api.nvim_create_autocmd("WinLeave", {
    group = group_id,
    pattern = "*",
    callback = function()
      matchdelete(true)
    end,
  })
  api.nvim_create_autocmd("ColorScheme", {
    group = group_id,
    pattern = "*",
    callback = set_highlight,
  })
end

local function del_autocmds()
  enabled = false
  matchdelete(true)
  pcall(api.nvim_del_augroup_by_id, group_id)
end

if vim.g.cursorword_disable_at_startup ~= true then
  set_autocmds()
end
api.nvim_create_user_command("CursorWordDisable", del_autocmds, {})
api.nvim_create_user_command("CursorWordEnable", set_autocmds, {})
api.nvim_create_user_command("CursorWordToggle", function()
  if enabled then
    del_autocmds()
  else
    set_autocmds()
  end
end, {})
