# murabox

[![test](https://github.com/xThuby/murabox/actions/workflows/test.yml/badge.svg)](https://github.com/xThuby/murabox/actions/workflows/test.yml)

A Neovim colourscheme based on Handmade Hero.

Warm tan on near-black, goldenrod keywords and types, olive drab literals, and
not much else. It is deliberately flat: functions, variables, members and plain
text all share one colour, so nothing competes for your attention and the
structure of the code has to carry itself.

```
#161616   background
#A08563   foreground         functions, variables, members
#CDAA7D   emphasis           burlywood3
#CD950C   keywords, types    DarkGoldenrod3
#6B8E23   strings, numbers   olive drab
#7F7F7F   comments           gray50
#40FF40   cursor (normal mode)
```

burlywood3 is the reference tan, but it is glaring as the colour most of the
screen is painted with, so body text sits a step below it and burlywood3 is kept
for emphasis. To use it for body text:

```lua
require("murabox").setup({ palette = { fg = "#CDAA7D" } })
```

The cursor is a block in every mode, green in normal, red in insert and blue in
visual.

Written in Lua, with support for Treesitter, LSP semantic tokens, diagnostics
and the usual plugin ecosystem (Telescope, gitsigns, nvim-cmp, blink.cmp,
neo-tree, nvim-tree, which-key, indent-blankline, mini.nvim, lazy.nvim,
flash/leap/hop, todo-comments, fzf-lua). A lualine theme is included.

## Install

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "xThuby/murabox",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("murabox")
  end,
}
```

If you want to pass options, call `setup` before the `colorscheme` command:

```lua
{
  "xThuby/murabox",
  lazy = false,
  priority = 1000,
  opts = {
    flat = true,
    transparent = false,
  },
  config = function(_, opts)
    require("murabox").setup(opts)
    vim.cmd.colorscheme("murabox")
  end,
}
```

Requires Neovim 0.10+ and a true-colour terminal (`termguicolors` is set for
you). CI runs against stable.

## Configuration

Defaults:

```lua
require("murabox").setup({
  -- Show the terminal background through Neovim.
  transparent = false,

  -- Keep the flat look, where functions, variables and members share the base
  -- foreground colour and types sit with the keywords. Set false to pull
  -- functions and types out with some contrast of their own.
  flat = true,

  -- No italics or bold anywhere by default.
  styles = {
    comments  = { italic = false },
    keywords  = { bold = false },
    functions = {},
    variables = {},
    types     = {},
  },

  -- Dim inactive splits slightly.
  dim_inactive = false,

  -- Set g:terminal_color_0 .. 15 from the palette.
  terminal_colors = true,

  -- Colour the cursor by mode: green normal, red insert, blue visual.
  mode_cursor = true,

  -- Highlight TODO / NOTE / IMPORTANT / STUDY with a solid block. See the
  -- note below.
  comment_keywords = true,

  -- Change palette colours. Table (merged) or function (mutates in place).
  palette = {},

  -- Override highlight groups. Table of `{ group = spec }`, or a function
  -- `(highlights, colors)` called after the defaults are built.
  highlights = {},
})
```

### Examples

Give types and functions a bit of contrast:

```lua
require("murabox").setup({ flat = false })
```

Change the mode cursor colours:

```lua
require("murabox").setup({
  palette = {
    cursor = "#40FF40",         -- normal
    cursor_insert = "#FF4040",  -- insert
    cursor_visual = "#4080FF",  -- visual
  },
})
```

Push the background darker and tweak a group:

```lua
require("murabox").setup({
  palette = { bg = "#0E0E0E" },
  highlights = function(hl, c)
    hl.Comment = { fg = c.grey_light, italic = true }
    hl.CursorLine = { bg = "#1A1A1A" }
  end,
})
```

Use the palette in your own config:

```lua
local c = require("murabox").get_colors()
```

### lualine

```lua
require("lualine").setup({ options = { theme = "murabox" } })
```

## Comment keywords

`comment_keywords` highlights `TODO`, `NOTE`, `IMPORTANT` and `STUDY` with a
solid background block so they can't be scrolled past. It uses window-local
matches rather than syntax rules, so it works in Treesitter-highlighted buffers
too — the tradeoff is that the words are matched anywhere in the buffer, not
only inside comments. Set `comment_keywords = false` to turn it off, or use
[todo-comments.nvim](https://github.com/folke/todo-comments.nvim), whose groups
are themed here as well.

## Mode cursor

`mode_cursor` sets `'guicursor'` so the cursor is green in normal mode, red in
insert and blue in visual. Because Neovim drives cursor colour through that
option rather than a highlight group alone, the colourscheme has to write it.
It saves your previous value and restores it if you load another colourscheme —
and if you set `'guicursor'` yourself after loading murabox, it leaves your
value alone rather than overwriting it later. Set `mode_cursor = false` to keep
full control; the `MuraboxCursorNormal` / `Insert` / `Visual` groups stay
defined either way, so you can wire up your own spec.

Terminal support for cursor colour varies. It works in most modern terminals
and in the GUI clients; a few will show the shape change but not the colour.

## On accuracy

The core colours come from Casey Muratori's Emacs configuration, cross-checked
against screen captures from the series. Everything else — float windows,
diagnostics, git signs, plugin groups — has no counterpart there and was derived
to fit, and a few choices depart from the source where it made for a better
editor. This is not a byte-exact port. Corrections welcome via an issue.

## Development

The smoke test covers the core palette, every option, and the cleanup paths for
`'guicursor'` and the keyword matches. Run it from the repo root:

```bash
nvim --headless --clean -u NONE -l tests/smoke.lua
```

It exits non-zero on failure and runs in CI against stable and nightly Neovim.
If you change a core colour, update the assertions in `tests/smoke.lua` in the
same commit — they exist to make a palette change deliberate rather than
accidental.

## Licence

MIT
