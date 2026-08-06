--- Mode-dependent cursor colour.
---
--- Green in normal mode (the colour from the original config), red in insert,
--- blue in visual. Neovim drives this through 'guicursor', which names a
--- highlight group per mode, so the colourscheme has to set that option as
--- well as the groups. The previous value is saved and put back if another
--- colourscheme is loaded over the top, so we do not leave the option
--- rewritten behind us.

local M = {}

local group = vim.api.nvim_create_augroup("MuraboxCursor", { clear = true })

--- mode list : shape - highlight group
local spec = table.concat({
  "n-sm:block-MuraboxCursorNormal",
  "v-ve:block-MuraboxCursorVisual",
  -- Block in insert mode too: the mode reads from the colour, so there is no
  -- need to change shape as well.
  "i-ci:block-MuraboxCursorInsert",
  "r-cr:hor20-MuraboxCursorReplace",
  "c:block-MuraboxCursorCommand",
  "o:hor50-MuraboxCursorNormal",
}, ",")

--- The user's 'guicursor' from before we touched it.
local saved = nil

--- Point 'guicursor' at the murabox cursor groups.
function M.enable()
  if saved == nil and vim.o.guicursor ~= spec then
    saved = vim.o.guicursor
  end
  vim.o.guicursor = spec

  vim.api.nvim_clear_autocmds({ group = group })
  vim.api.nvim_create_autocmd("ColorSchemePre", {
    group = group,
    callback = function()
      M.disable()
    end,
  })
end

--- Restore whatever 'guicursor' was before.
---
--- Only put the old value back if 'guicursor' is still the one we set. If it
--- has changed since, the user set it themselves after loading the scheme,
--- and restoring a stale value over the top would throw their setting away.
function M.disable()
  vim.api.nvim_clear_autocmds({ group = group })
  if saved ~= nil and vim.o.guicursor == spec then
    vim.o.guicursor = saved
  end
  saved = nil
end

return M
