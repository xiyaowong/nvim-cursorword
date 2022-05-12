if vim.g.loaded_cursorword == nil then
  vim.g.loaded_cursorword = 1
  local augroupName = "CursorWord"

  local function setupAutocmds()
    local CursorWordGroup = vim.api.nvim_create_augroup(augroupName, {})
    vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
      group = CursorWordGroup,
      pattern = "*",
      callback = require'nvim-cursorword'.matchadd })

    vim.api.nvim_create_autocmd("WinLeave", {
      group = CursorWordGroup,
      pattern = "*",
      callback = require'nvim-cursorword'.matchdelete })
  end

  local function CursorWordDisable()
    if vim.fn.exists("#" .. augroupName) == 0 then return end
    vim.api.nvim_del_augroup_by_name(augroupName)
    require'nvim-cursorword'.matchdelete()
  end

  local function CursorWordEnable()
    if vim.fn.exists("#" .. augroupName) == 1 then return end
    setupAutocmds()
    require'nvim-cursorword'.matchadd()
  end

  local function CursorWordToggle()
    if vim.fn.exists("#" .. augroupName) == 0 then
      CursorWordEnable()
    else
      CursorWordDisable()
    end
  end

  if vim.g.cursorword_disable_at_startup == nil then
    setupAutocmds()
  end

  vim.api.nvim_create_user_command('CursorWordDisable', CursorWordDisable, {})
  vim.api.nvim_create_user_command('CursorWordEnable',  CursorWordEnable, {})
  vim.api.nvim_create_user_command('CursorWordToggle',  CursorWordToggle, {})

  vim.api.nvim_set_hl(0, "CursorWord", {underline = 1, default = 1})
end
