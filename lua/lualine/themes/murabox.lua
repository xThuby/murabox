--- lualine theme for murabox.
--- Use with: require("lualine").setup({ options = { theme = "murabox" } })

local c = require("murabox").get_colors()

return {
  normal = {
    a = { fg = c.bg, bg = c.keyword, gui = "bold" },
    b = { fg = c.fg, bg = c.bg_highlight },
    c = { fg = c.fg_dim, bg = c.bg_dark },
  },
  insert = {
    a = { fg = c.bg, bg = c.green, gui = "bold" },
    b = { fg = c.fg, bg = c.bg_highlight },
  },
  visual = {
    a = { fg = c.bg, bg = c.blue, gui = "bold" },
    b = { fg = c.fg, bg = c.bg_highlight },
  },
  replace = {
    a = { fg = c.bg, bg = c.red, gui = "bold" },
    b = { fg = c.fg, bg = c.bg_highlight },
  },
  command = {
    a = { fg = c.bg, bg = c.orange, gui = "bold" },
    b = { fg = c.fg, bg = c.bg_highlight },
  },
  terminal = {
    a = { fg = c.bg, bg = c.cyan, gui = "bold" },
    b = { fg = c.fg, bg = c.bg_highlight },
  },
  inactive = {
    a = { fg = c.fg_dark, bg = c.bg_dark },
    b = { fg = c.fg_dark, bg = c.bg_dark },
    c = { fg = c.fg_dark, bg = c.bg_dark },
  },
}
