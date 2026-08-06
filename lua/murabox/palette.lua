--- Murabox palette.
---
--- The core colours are taken from Casey Muratori's Emacs configuration as
--- used during the Handmade Hero series. The defining trait of that scheme is
--- how *flat* it is: types, functions, variables and plain text all share the
--- same burlywood tan, and only keywords (goldenrod) and strings (olive drab)
--- break away from it. Everything else here is derived to fill in the parts of
--- a modern editor that Emacs of that vintage simply did not have.

local M = {}

M.colors = {
  -- Core, straight from the Handmade Hero era config.
  bg = "#161616", -- (set-background-color "#161616")
  -- burlywood3 (#CDAA7D) is the reference tan, but at full strength it is
  -- glaring as the colour most of the screen is painted with. Body text sits
  -- one step below it; burlywood3 itself is kept as `fg_bright` for emphasis.
  -- Set `palette = { fg = "#CDAA7D" }` to go back to it.
  fg = "#A08563",
  cursor = "#40FF40", -- (set-cursor-color "#40FF40")
  comment = "#7F7F7F", -- gray50
  keyword = "#CD950C", -- DarkGoldenrod3
  string = "#6B8E23", -- olive drab

  -- Mode-dependent cursor colours. Green is the original; red and blue are
  -- built the same way (one channel at FF, the others at 40) so the three
  -- read as a set. Blue is lifted a little for legibility on a dark bg.
  cursor_insert = "#FF4040",
  cursor_visual = "#4080FF",
  cursor_replace = "#FF4040",
  cursor_command = "#CD950C",

  -- Derived background steps, for float windows, sidebars, cursorline and
  -- the statusline. Kept deliberately close to bg: the original had almost
  -- no chrome, and heavy panel contrast fights the flat look.
  bg_dark = "#101010",
  bg_float = "#131313",
  bg_highlight = "#1E1E1E",
  bg_visual = "#264458",
  bg_search = "#4A3A10",
  bg_search_cur = "#7A5E12",

  -- Derived foreground steps.
  fg_bright = "#CDAA7D", -- burlywood3, for the thing that must stand out
  fg_dim = "#8A7154", -- for punctuation and other quiet structure
  fg_dark = "#6E5C46", -- for non-current line numbers, inactive text

  -- Greys for borders, folds and other structural chrome.
  grey = "#4D4D4D",
  grey_dark = "#2A2A2A",
  grey_light = "#9A9A9A",

  -- Accents. Muted so they sit inside the warm palette instead of on top
  -- of it. Used for diagnostics, git state and the TODO/NOTE keywords.
  red = "#CC5555",
  orange = "#C97A40",
  yellow = "#CD950C", -- same goldenrod as keywords, by design
  green = "#6B8E23", -- same olive drab as strings, by design
  green_bright = "#40FF40", -- cursor green; used sparingly
  cyan = "#7C9FA6",
  blue = "#5F87AF",
  magenta = "#A07AA0",

  -- Diff backgrounds, tinted rather than saturated.
  diff_add = "#1E2A14",
  diff_change = "#2A2412",
  diff_delete = "#2E1818",
  diff_text = "#3E3618",

  none = "NONE",
}

--- Build the working palette for a given config.
--- @param config table resolved murabox config
--- @return table palette
function M.build(config)
  local c = vim.deepcopy(M.colors)

  if config.transparent then
    c.bg = "NONE"
    c.bg_dark = "NONE"
    c.bg_float = "NONE"
  end

  if type(config.palette) == "table" then
    c = vim.tbl_extend("force", c, config.palette)
  elseif type(config.palette) == "function" then
    config.palette(c)
  end

  return c
end

return M
