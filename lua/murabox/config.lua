--- Murabox configuration.

local M = {}

M.defaults = {
  --- Use the normal background colour, or let the terminal show through.
  transparent = false,

  --- Keep the flat look, where functions, variables and members share the base
  --- foreground colour and types sit with the keywords. Set to false to let
  --- types and functions pick up a little contrast, which some people find
  --- easier to scan in large files.
  flat = true,

  --- No italics or bold anywhere by default.
  styles = {
    comments = { italic = false },
    keywords = { bold = false },
    functions = {},
    variables = {},
    types = {},
  },

  --- Dim the background of inactive splits and sidebars slightly.
  dim_inactive = false,

  --- Set g:terminal_color_0 .. 15 from the palette.
  terminal_colors = true,

  --- Colour the cursor by mode: green in normal, red in insert, blue in
  --- visual. This sets 'guicursor', restoring your previous value if another
  --- colourscheme is loaded. Set false to keep full control of the option.
  mode_cursor = true,

  --- Colour TODO / NOTE / IMPORTANT / STUDY style keywords in comments.
  comment_keywords = true,

  --- Extend or replace palette colours. Either a table merged over the
  --- palette, or a function receiving the palette table to mutate in place.
  palette = {},

  --- Override highlight groups. Either a table of `{ group = spec }`, or a
  --- function `(highlights, colors)` called after the defaults are built.
  highlights = {},
}

M.options = vim.deepcopy(M.defaults)

--- Merge user options over the defaults.
--- @param opts table|nil
--- @return table resolved options
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
  return M.options
end

--- Resolve options for a load, without persisting them.
--- @param opts table|nil
--- @return table
function M.extend(opts)
  if not opts then
    return M.options
  end
  return vim.tbl_deep_extend("force", vim.deepcopy(M.options), opts)
end

return M
