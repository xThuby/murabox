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

-- The core colours are the point of the scheme; pin them.
check("Normal fg is knocked-back tan", hl("Normal").fg == 0xA08563, hex(hl("Normal").fg))
check("burlywood3 kept as fg_bright", hl("Title").fg == 0xCDAA7D, hex(hl("Title").fg))
check("Normal bg is #161616", hl("Normal").bg == 0x161616, hex(hl("Normal").bg))
check("Keyword is DarkGoldenrod3", hl("Keyword").fg == 0xCD950C, hex(hl("Keyword").fg))
check("String is olive drab", hl("String").fg == 0x6B8E23, hex(hl("String").fg))
check("Comment is gray50", hl("Comment").fg == 0x7F7F7F, hex(hl("Comment").fg))
check("Cursor bg is #40FF40", hl("Cursor").bg == 0x40FF40, hex(hl("Cursor").bg))

check("Comment not italic by default", hl("Comment").italic ~= true, "italic set")
check("@keyword.return themed", hl("@keyword.return").fg == 0xCD950C, hex(hl("@keyword.return").fg))
check("@variable is flat fg", hl("@variable").fg == 0xA08563, hex(hl("@variable").fg))

-- Types share the keyword goldenrod, and numeric literals share the string
-- colour. Both are visible in the reference screenshots.
check("Type is goldenrod", hl("Type").fg == 0xCD950C, hex(hl("Type").fg))
check("@type is goldenrod", hl("@type").fg == 0xCD950C, hex(hl("@type").fg))
check("Number matches String", hl("Number").fg == hl("String").fg, hex(hl("Number").fg))
check("@number matches @string", hl("@number").fg == hl("@string").fg, hex(hl("@number").fg))
check("String is olive drab", hl("String").fg == 0x6B8E23, hex(hl("String").fg))
check("Function is flat fg", hl("Function").fg == 0xA08563, hex(hl("Function").fg))

-- Preprocessor directives sit a step brighter than body text, and are never
-- the keyword goldenrod.
check("PreProc is fg_bright", hl("PreProc").fg == 0xCDAA7D, hex(hl("PreProc").fg))
check("PreCondit is fg_bright", hl("PreCondit").fg == 0xCDAA7D, hex(hl("PreCondit").fg))
check("@preproc is fg_bright", hl("@preproc").fg == 0xCDAA7D, hex(hl("@preproc").fg))
check(
  "@keyword.directive is fg_bright",
  hl("@keyword.directive").fg == 0xCDAA7D,
  hex(hl("@keyword.directive").fg)
)
check("PreProc is brighter than Normal", hl("PreProc").fg ~= hl("Normal").fg, "same as Normal")
check("PreProc is not the keyword colour", hl("PreProc").fg ~= hl("Keyword").fg, "same as Keyword")

-- Line numbers read as ordinary text.
check("LineNr matches Normal", hl("LineNr").fg == hl("Normal").fg, hex(hl("LineNr").fg))

-- Mode-dependent cursor.
check("cursor normal is green", hl("MuraboxCursorNormal").bg == 0x40FF40, hex(hl("MuraboxCursorNormal").bg))
check("cursor insert is red", hl("MuraboxCursorInsert").bg == 0xFF4040, hex(hl("MuraboxCursorInsert").bg))
check("cursor visual is blue", hl("MuraboxCursorVisual").bg == 0x4080FF, hex(hl("MuraboxCursorVisual").bg))
check("guicursor names normal group", vim.o.guicursor:match("MuraboxCursorNormal") ~= nil, vim.o.guicursor)
check("guicursor names insert group", vim.o.guicursor:match("MuraboxCursorInsert") ~= nil, vim.o.guicursor)
check("guicursor names visual group", vim.o.guicursor:match("MuraboxCursorVisual") ~= nil, vim.o.guicursor)
check(
  "insert cursor is a block",
  vim.o.guicursor:match("i%-ci:block%-MuraboxCursorInsert") ~= nil,
  vim.o.guicursor
)
-- Every red in the scheme is the full red, matching the insert cursor.
check("DiagnosticError is full red", hl("DiagnosticError").fg == 0xFF4040, hex(hl("DiagnosticError").fg))
check("SpecialChar is full red", hl("SpecialChar").fg == 0xFF4040, hex(hl("SpecialChar").fg))
check("@string.escape is full red", hl("@string.escape").fg == 0xFF4040, hex(hl("@string.escape").fg))
check("GitSignsDelete is full red", hl("GitSignsDelete").fg == 0xFF4040, hex(hl("GitSignsDelete").fg))
check(
  "escape red matches insert cursor",
  hl("@string.escape").fg == hl("MuraboxCursorInsert").bg,
  hex(hl("@string.escape").fg)
)
check("TelescopeSelection set", hl("TelescopeSelection").bg ~= nil, "missing")
check("terminal_color_3 set", vim.g.terminal_color_3 == "#CD950C", tostring(vim.g.terminal_color_3))
-- Comment keywords colour the letters, not the line behind them.
check("MuraboxTodo is goldenrod text", hl("MuraboxTodo").fg == 0xCD950C, hex(hl("MuraboxTodo").fg))
check("MuraboxTodo has no background", hl("MuraboxTodo").bg == nil, hex(hl("MuraboxTodo").bg))
check("MuraboxNote has no background", hl("MuraboxNote").bg == nil, hex(hl("MuraboxNote").bg))
check("MuraboxImportant is full red", hl("MuraboxImportant").fg == 0xFF4040, hex(hl("MuraboxImportant").fg))
check("Todo has no background", hl("Todo").bg == nil, hex(hl("Todo").bg))

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
check("flat=false gives Function contrast", hl("Function").fg == 0xCDAA7D, hex(hl("Function").fg))

require("murabox").setup({ preproc = "orange" })
vim.cmd.colorscheme("murabox")
check("preproc=orange sets PreProc", hl("PreProc").fg == 0xE95410, hex(hl("PreProc").fg))
check("preproc=orange sets @preproc", hl("@preproc").fg == 0xE95410, hex(hl("@preproc").fg))
check(
  "preproc=orange sets @keyword.directive",
  hl("@keyword.directive").fg == 0xE95410,
  hex(hl("@keyword.directive").fg)
)
check("preproc=orange leaves Normal alone", hl("Normal").fg == 0xA08563, hex(hl("Normal").fg))

-- An unknown value falls back to the default rather than erroring.
require("murabox").setup({ preproc = "nonsense" })
vim.cmd.colorscheme("murabox")
check("unknown preproc falls back to bright", hl("PreProc").fg == 0xCDAA7D, hex(hl("PreProc").fg))

require("murabox").setup({ preproc = "bright" })
vim.cmd.colorscheme("murabox")
check("preproc=bright is the default look", hl("PreProc").fg == 0xCDAA7D, hex(hl("PreProc").fg))

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

-- Contrast ---------------------------------------------------------------
-- No readable text may be dark on a dark background. Decorative chrome
-- (separators, borders, indent guides, deliberately hidden groups) is exempt
-- because it draws lines and fills, not letters.
local decorative = {
  BlinkCmpDocBorder = true,
  BlinkCmpMenuBorder = true,
  EndOfBuffer = true,
  FloatBorder = true,
  FzfLuaBorder = true,
  IblIndent = true,
  IblScope = true,
  IblWhitespace = true,
  Ignore = true,
  LazyProgressTodo = true,
  LspCodeLensSeparator = true,
  MiniIndentscopeSymbol = true,
  MsgSeparator = true,
  NeoTreeIndentMarker = true,
  NeoTreeWinSeparator = true,
  NonText = true,
  NotifyDEBUGBorder = true,
  NvimTreeIndentMarker = true,
  NvimTreeWinSeparator = true,
  TelescopeBorder = true,
  TelescopePromptBorder = true,
  WhichKeyBorder = true,
  WinSeparator = true,
  Whitespace = true,
}

local function rgb(v)
  if type(v) == "string" then
    v = tonumber((v:gsub("#", "")), 16)
  end
  if type(v) ~= "number" then
    return nil
  end
  return { math.floor(v / 65536) % 256, math.floor(v / 256) % 256, v % 256 }
end

local function luminance(col)
  local function channel(x)
    x = x / 255
    if x <= 0.03928 then
      return x / 12.92
    end
    return ((x + 0.055) / 1.055) ^ 2.4
  end
  return 0.2126 * channel(col[1]) + 0.7152 * channel(col[2]) + 0.0722 * channel(col[3])
end

local function contrast(fg, bg)
  local a, b = luminance(fg), luminance(bg)
  if a < b then
    a, b = b, a
  end
  return (a + 0.05) / (b + 0.05)
end

local MIN_CONTRAST = 3.0
local defaults = require("murabox.config").setup({})
local palette = require("murabox.palette").build(defaults)
local built = require("murabox.highlights").build(defaults, palette)
local page_bg = rgb(built.Normal.bg)
local dim = {}

for name, spec in pairs(built) do
  if type(spec) == "table" and spec.fg and not decorative[name] then
    local fg, bg = rgb(spec.fg), spec.bg and rgb(spec.bg) or page_bg
    if fg and bg then
      local r = contrast(fg, bg)
      if r < MIN_CONTRAST then
        table.insert(dim, ("%s (%.2f)"):format(name, r))
      end
    end
  end
end
table.sort(dim)
check("no text group is below 3:1 contrast", #dim == 0, table.concat(dim, ", "))

print(("\n%d failure(s)"):format(#failures))
vim.cmd(#failures == 0 and "qall!" or "cquit")
