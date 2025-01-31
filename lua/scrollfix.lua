local M = {}

-- default configuration
---@class ScrollFixOptions
---@field scrollfix number
---@field fixeof boolean
---@field scrollinfo boolean
---@field skip_filetypes table<string>
M.options = {
  scrollfix = 50,
  fixeof = true,
  scrollinfo = false,
  skip_filetypes = {},
}

-- commands to change scrollfix value
vim.api.nvim_create_user_command("FIXOFF", function()
  M.options.scrollfix = -1
end, {})

vim.api.nvim_create_user_command("FIX", function(opts)
  local value = tonumber(opts.args)
  if value then
    M.options.scrollfix = value
  else
    vim.api.nvim_err_writeln("Invalid value for FIX command")
  end
end, { nargs = 1 })

-- function to handle the cursor position
local function scrollfix_cursor()
  for _, value in ipairs(M.options.skip_filetypes) do
    if value == vim.bo.filetype then
      return
    end
  end
  if M.options.scrollfix < 0 then
    return
  end
  -- enable for normal and insert mode only
  local mode = vim.api.nvim_get_mode().mode
  if mode ~= "n" and mode ~= "i" then
    return
  end
  vim.opt.scrolloff = 0

  local win_height = vim.api.nvim_win_get_height(0)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local topline = vim.fn.line("w0")
  local fixline = math.floor(win_height * M.options.scrollfix / 100)

  -- early return if cursor is already at the correct position
  if cursor_line < fixline then
    -- if the cursor falls within the initial non-fix range
    -- fix the first line to be the topline
    vim.fn.winrestview({ topline = 1 })
    return
  end
  if cursor_line - topline + 1 == fixline then
    return
  end

  -- if fixeof is disabled and the cursor falls within the last non-fix range
  -- don't fix the cursor and force the eofline to be the bottomline
  if not M.options.fixeof then
    local eofline = vim.fn.line("$")
    if cursor_line > eofline - win_height + fixline then
      vim.fn.winrestview({ topline = eofline - win_height + 1 })
      return
    end
  end

  -- adjust the topline to maintain the fixed cursor position
  vim.fn.winrestview({ topline = cursor_line - fixline + 1 })

  -- optionally display a message
  if M.options.scrollinfo then
    if vim.w.scrollfix_line ~= fixline then
      vim.w.scrollfix_line = fixline
      vim.notify(
        string.format(
          "Scroll fixed at visual line %d of window height %d (%d%%)",
          fixline,
          win_height,
          M.options.scrollfix
        ),
        vim.log.levels.INFO,
        { title = "scrollfix" }
      )
    end
  end
end

-- autocmd to trigger scrollfix when cursor moves
vim.api.nvim_create_augroup("ScrollFix", { clear = true })
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "ModeChanged" }, {
  group = "ScrollFix",
  callback = scrollfix_cursor,
})

-- turn scroll into cursor move to prevent win scroll jerkiness
vim.keymap.set({ "n", "i" }, "<ScrollWheelUp>", "<Up>")
vim.keymap.set({ "n", "i" }, "<ScrollWheelDown>", "<Down>")

---@param opts? ScrollFixOptions
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
