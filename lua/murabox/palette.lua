--- Murabox palette.
---
--- The core colours come from Casey Muratori's Emacs configuration, used
--- during Handmade Hero. The scheme is deliberately flat: functions,
--- variables, members and plain text all share one tan, types sit with the
--- keywords on goldenrod, and literals are olive drab. That is the whole
--- vocabulary. Everything below the core block is derived to cover the parts
--- of a modern editor that setup had no equivalent for.

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

  -- Mode-dependent cursor colours. Red and blue are built the same way as the
  -- green above (one channel at FF, the others at 40) so the three read as a
  -- set. Blue is lifted a little for legibility on a dark background.
  cursor_insert = "#FF4040",
  cursor_visual = "#4080FF",
  cursor_replace = "#FF4040",
  cursor_command = "#CD950C",

  -- Derived background steps, for float windows, sidebars, cursorline and
  -- the statusline. Kept deliberately close to bg, since heavy panel contrast
  -- fights the flat look.
  bg_dark = "#101010",
  bg_float = "#131313",
  bg_highlight = "#1E1E1E",
  bg_visual = "#264458",
  bg_search = "#4A3A10",
  bg_search_cur = "#8A6A15",

  -- Derived foreground steps.
  fg_bright = "#CDAA7D", -- burlywood3, for the thing that must stand out
  fg_dim = "#8A7154", -- for punctuation and other quiet structure
  fg_dark = "#7D6950", -- dimmest text step, kept legible against bg

  -- Greys for borders, folds and other structural chrome.
  grey = "#4D4D4D",
  grey_dark = "#2A2A2A",
  grey_light = "#9A9A9A",

  -- Accents. Muted so they sit inside the warm palette instead of on top
  -- of it. Used for diagnostics, git state and the TODO/NOTE keywords.
  -- Full red, the same value as the insert cursor. Every red in the scheme
  -- comes from here, so errors, deletions and escape sequences all agree.
  red = "#FF4040",
  orange = "#C97A40",
  orange_red = "#E95410", -- optional preprocessor colour, see `preproc`
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
