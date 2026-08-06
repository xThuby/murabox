--- Murabox: a Neovim colourscheme based on Handmade Hero.

local config = require("murabox.config")
local palette = require("murabox.palette")
local highlights = require("murabox.highlights")

local M = {}

M.config = config

--- Store options for a later `:colorscheme murabox`.
--- @param opts table|nil
function M.setup(opts)
  config.setup(opts)
end

--- Terminal colours, mapped onto the palette. The scheme has no real blue or
--- magenta of its own, so those slots use the muted accents.
local function set_terminal_colors(c)
  local ansi = {
    [0] = c.bg_highlight,
    [1] = c.red,
    [2] = c.green,
    [3] = c.keyword,
    [4] = c.blue,
    [5] = c.magenta,
    [6] = c.cyan,
    [7] = c.fg,
    [8] = c.grey,
    [9] = c.red,
    [10] = c.green_bright,
    [11] = c.fg_bright,
    [12] = c.blue,
    [13] = c.magenta,
    [14] = c.cyan,
    [15] = c.fg_bright,
  }
  for i, colour in pairs(ansi) do
    vim.g["terminal_color_" .. i] = colour
  end
end

--- Apply the colourscheme.
--- @param opts table|nil options merged over anything passed to `setup`
function M.load(opts)
  local cfg = config.extend(opts)

  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "murabox"

  local c = palette.build(cfg)
  local groups = highlights.build(cfg, c)

  local set_hl = vim.api.nvim_set_hl
  for group, spec in pairs(groups) do
    set_hl(0, group, spec)
  end

  if cfg.terminal_colors then
    set_terminal_colors(c)
  end

  local keywords = require("murabox.keywords")
  if cfg.comment_keywords then
    keywords.enable()
  else
    keywords.disable()
  end

  local cursor = require("murabox.cursor")
  if cfg.mode_cursor then
    cursor.enable()
  else
    cursor.disable()
  end

  M.colors = c
end

--- The resolved palette, useful for statusline configs and the like.
--- @return table
function M.get_colors()
  return M.colors or palette.build(config.options)
end

return M
