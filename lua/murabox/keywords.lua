--- Comment keyword highlighting.
---
--- The original config made TODO / NOTE / IMPORTANT / STUDY jump off the
--- screen with a solid background block, so a note left in a file could not be
--- missed while scrolling. Treesitter-highlighted buffers ignore old-style
--- `syntax match` rules, so this uses window-local matches instead, which work
--- regardless of which highlighting engine a buffer uses.

local M = {}

local group = vim.api.nvim_create_augroup("MuraboxKeywords", { clear = true })

--- Keyword -> highlight group. Priority is low so real syntax wins ties.
local patterns = {
  { pattern = [[\<TODO\>]], hl = "MuraboxTodo" },
  { pattern = [[\<NOTE\>]], hl = "MuraboxNote" },
  { pattern = [[\<IMPORTANT\>]], hl = "MuraboxImportant" },
  { pattern = [[\<STUDY\>]], hl = "MuraboxStudy" },
}

--- Buffer types that should never get the matches.
local function skip_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return true
  end
  local bt = vim.bo[buf].buftype
  return bt ~= "" and bt ~= "acwrite"
end

local function apply(win)
  if not vim.api.nvim_win_is_valid(win) then
    return
  end
  if skip_buffer(vim.api.nvim_win_get_buf(win)) then
    return
  end
  -- Already applied to this window.
  local ok, applied = pcall(vim.api.nvim_win_get_var, win, "murabox_keywords")
  if ok and applied then
    return
  end

  vim.api.nvim_win_call(win, function()
    for _, p in ipairs(patterns) do
      pcall(vim.fn.matchadd, p.hl, p.pattern, -1)
    end
  end)
  pcall(vim.api.nvim_win_set_var, win, "murabox_keywords", true)
end

--- Remove the matches from every window.
local function clear()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, applied = pcall(vim.api.nvim_win_get_var, win, "murabox_keywords")
    if ok and applied then
      vim.api.nvim_win_call(win, function()
        for _, m in ipairs(vim.fn.getmatches()) do
          if m.group and m.group:match("^Murabox") then
            pcall(vim.fn.matchdelete, m.id)
          end
        end
      end)
      pcall(vim.api.nvim_win_set_var, win, "murabox_keywords", false)
    end
  end
end

--- Enable keyword matching, now and for future windows.
function M.enable()
  vim.api.nvim_clear_autocmds({ group = group })

  vim.api.nvim_create_autocmd({ "BufWinEnter", "WinNew", "FileType" }, {
    group = group,
    callback = function()
      apply(vim.api.nvim_get_current_win())
    end,
  })

  -- Drop the matches if another colourscheme is loaded over the top.
  vim.api.nvim_create_autocmd("ColorSchemePre", {
    group = group,
    callback = function()
      clear()
      vim.api.nvim_clear_autocmds({ group = group })
    end,
  })

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    apply(win)
  end
end

--- Disable keyword matching and remove existing matches.
function M.disable()
  vim.api.nvim_clear_autocmds({ group = group })
  clear()
end

return M
