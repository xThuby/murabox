-- Smoke test for murabox.
--
-- Run from the repo root with:
--   nvim --headless --clean -u NONE -l tests/smoke.lua
--
-- Exits 0 when everything passes, non-zero otherwise, so it can be wired into
-- CI or a pre-push hook.

-- Resolve the repo root from this script's own path, so the test works no
-- matter what directory it is invoked from.
local this = debug.getinfo(1, "S").source:sub(2)
local root = vim.fn.fnamemodify(this, ":p:h:h"):gsub("\\", "/")
vim.opt.runtimepath:prepend(root)

local failures = {}

local function check(name, cond, detail)
  if cond then
    print(("  ok   %s"):format(name))
  else
    print(("  FAIL %s -- %s"):format(name, detail or ""))
    table.insert(failures, name)
  end
end

local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function hex(n)
  return n and string.format("#%06X", n) or "nil"
end

-- Defaults ------------------------------------------------------------------
local ok, err = pcall(vim.cmd.colorscheme, "murabox")
check("colorscheme murabox loads", ok, tostring(err))
check("g:colors_name set", vim.g.colors_name == "murabox", tostring(vim.g.colors_name))

-- The six core colours are the point of the scheme; pin them.
check("Normal fg is burlywood3", hl("Normal").fg == 0xCDAA7D, hex(hl("Normal").fg))
check("Normal bg is #161616", hl("Normal").bg == 0x161616, hex(hl("Normal").bg))
check("Keyword is DarkGoldenrod3", hl("Keyword").fg == 0xCD950C, hex(hl("Keyword").fg))
check("String is olive drab", hl("String").fg == 0x6B8E23, hex(hl("String").fg))
check("Comment is gray50", hl("Comment").fg == 0x7F7F7F, hex(hl("Comment").fg))
check("Cursor bg is #40FF40", hl("Cursor").bg == 0x40FF40, hex(hl("Cursor").bg))

check("Comment not italic by default", hl("Comment").italic ~= true, "italic set")
check("@keyword.return themed", hl("@keyword.return").fg == 0xCD950C, hex(hl("@keyword.return").fg))
check("@variable is flat fg", hl("@variable").fg == 0xCDAA7D, hex(hl("@variable").fg))

-- Types share the keyword goldenrod, and numeric literals share the string
-- colour. Both are visible in the reference screenshots.
check("Type is goldenrod", hl("Type").fg == 0xCD950C, hex(hl("Type").fg))
check("@type is goldenrod", hl("@type").fg == 0xCD950C, hex(hl("@type").fg))
check("Number matches String", hl("Number").fg == hl("String").fg, hex(hl("Number").fg))
check("@number matches @string", hl("@number").fg == hl("@string").fg, hex(hl("@number").fg))
check("String is olive drab", hl("String").fg == 0x6B8E23, hex(hl("String").fg))
check("Function is flat fg", hl("Function").fg == 0xCDAA7D, hex(hl("Function").fg))

-- Mode-dependent cursor.
check("cursor normal is green", hl("MuraboxCursorNormal").bg == 0x40FF40, hex(hl("MuraboxCursorNormal").bg))
check("cursor insert is red", hl("MuraboxCursorInsert").bg == 0xFF4040, hex(hl("MuraboxCursorInsert").bg))
check("cursor visual is blue", hl("MuraboxCursorVisual").bg == 0x4080FF, hex(hl("MuraboxCursorVisual").bg))
check("guicursor names normal group", vim.o.guicursor:match("MuraboxCursorNormal") ~= nil, vim.o.guicursor)
check("guicursor names insert group", vim.o.guicursor:match("MuraboxCursorInsert") ~= nil, vim.o.guicursor)
check("guicursor names visual group", vim.o.guicursor:match("MuraboxCursorVisual") ~= nil, vim.o.guicursor)
check("DiagnosticError set", hl("DiagnosticError").fg ~= nil, "missing")
check("TelescopeSelection set", hl("TelescopeSelection").bg ~= nil, "missing")
check("terminal_color_3 set", vim.g.terminal_color_3 == "#CD950C", tostring(vim.g.terminal_color_3))
check("MuraboxTodo defined", hl("MuraboxTodo").bg == 0xCD950C, hex(hl("MuraboxTodo").bg))

-- No highlight group should carry a nil-ish or malformed spec.
local groups = require("murabox.highlights").build(
  require("murabox.config").options,
  require("murabox.palette").build(require("murabox.config").options)
)
local bad = {}
for group, spec in pairs(groups) do
  if type(spec) ~= "table" then
    table.insert(bad, group)
  end
end
check("all highlight specs are tables", #bad == 0, table.concat(bad, ", "))

-- Options -------------------------------------------------------------------
require("murabox").setup({ flat = false })
vim.cmd.colorscheme("murabox")
check("flat=false separates @type from keywords", hl("@type").fg == 0xC97A40, hex(hl("@type").fg))
check("flat=false gives Function contrast", hl("Function").fg == 0xE6C79C, hex(hl("Function").fg))

-- mode_cursor=false must leave 'guicursor' alone.
local before = "n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.o.guicursor = before
require("murabox").setup({ mode_cursor = false })
vim.cmd.colorscheme("murabox")
check("mode_cursor=false leaves guicursor alone", vim.o.guicursor == before, vim.o.guicursor)

require("murabox").setup({ transparent = true })
vim.cmd.colorscheme("murabox")
check("transparent clears Normal bg", hl("Normal").bg == nil, hex(hl("Normal").bg))

require("murabox").setup({
  transparent = false,
  palette = { bg = "#0E0E0E" },
  highlights = function(h, c)
    h.Comment = { fg = c.grey_light, italic = true }
  end,
})
vim.cmd.colorscheme("murabox")
check("palette override applies", hl("Normal").bg == 0x0E0E0E, hex(hl("Normal").bg))
check("highlights function override applies", hl("Comment").italic == true, "not italic")

require("murabox").setup({ highlights = { Comment = { fg = "#123456" } } })
vim.cmd.colorscheme("murabox")
check("highlights table override applies", hl("Comment").fg == 0x123456, hex(hl("Comment").fg))

require("murabox").setup({ styles = { comments = { italic = true } } })
vim.cmd.colorscheme("murabox")
check("styles.comments applies", hl("Comment").italic == true, "not italic")

-- Comment keywords ----------------------------------------------------------
require("murabox").setup({})
vim.cmd.colorscheme("murabox")
vim.cmd("enew")
vim.api.nvim_buf_set_lines(0, 0, -1, false, { "// TODO: fix this", "int x = 0;" })
vim.cmd("doautocmd BufWinEnter")
local found = false
for _, m in ipairs(vim.fn.getmatches()) do
  if m.group == "MuraboxTodo" then
    found = true
  end
end
check("keyword match applied to window", found, "no MuraboxTodo match")

-- lualine -------------------------------------------------------------------
local ok_ll, theme = pcall(dofile, root .. "/lua/lualine/themes/murabox.lua")
check("lualine theme loads", ok_ll and type(theme) == "table" and theme.normal ~= nil, tostring(theme))

-- Cleanup on switching away -------------------------------------------------
local user_guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.o.guicursor = user_guicursor
require("murabox").setup({ mode_cursor = true })
vim.cmd.colorscheme("murabox")
check("guicursor rewritten while active", vim.o.guicursor ~= user_guicursor, vim.o.guicursor)

vim.cmd.colorscheme("default")
check("guicursor restored on switch away", vim.o.guicursor == user_guicursor, vim.o.guicursor)

local leftover = false
for _, m in ipairs(vim.fn.getmatches()) do
  if m.group and m.group:match("^Murabox") then
    leftover = true
  end
end
check("matches cleared on colorscheme switch", not leftover, "leftover matches")

print(("\n%d failure(s)"):format(#failures))
vim.cmd(#failures == 0 and "qall!" or "cquit")
