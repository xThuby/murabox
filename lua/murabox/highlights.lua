--- Murabox highlight groups.

local M = {}

--- @param config table resolved config
--- @param c table palette
--- @return table<string, table> highlight groups
function M.build(config, c)
  local styles = config.styles or {}

  -- Types carry the same goldenrod as keywords; functions, variables and
  -- members are all the same flat tan. `flat = false` pulls functions and
  -- types apart a little, without leaving the palette.
  local fn_fg = config.flat and c.fg or c.fg_bright
  local type_fg = config.flat and c.keyword or c.orange

  local function style(base, extra)
    return vim.tbl_extend("force", base, extra or {})
  end

  local hl = {
    -- ==================================================================
    -- Editor
    -- ==================================================================
    Normal = { fg = c.fg, bg = c.bg },
    NormalNC = { fg = c.fg, bg = config.dim_inactive and c.bg_dark or c.bg },
    NormalFloat = { fg = c.fg, bg = c.bg_float },
    FloatBorder = { fg = c.grey, bg = c.bg_float },
    FloatTitle = { fg = c.fg_dim, bg = c.bg_float },

    Cursor = { fg = c.bg, bg = c.cursor },
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    TermCursor = { link = "Cursor" },

    -- Mode-dependent cursor. These are referenced from 'guicursor' when
    -- `mode_cursor` is enabled; they are always defined so they can be
    -- wired up by hand if it is not.
    MuraboxCursorNormal = { fg = c.bg, bg = c.cursor },
    MuraboxCursorInsert = { fg = c.bg, bg = c.cursor_insert },
    MuraboxCursorVisual = { fg = c.bg, bg = c.cursor_visual },
    MuraboxCursorReplace = { fg = c.bg, bg = c.cursor_replace },
    MuraboxCursorCommand = { fg = c.bg, bg = c.cursor_command },

    TermCursorNC = { fg = c.bg, bg = c.grey },
    CursorLine = { bg = c.bg_highlight },
    CursorColumn = { bg = c.bg_highlight },
    ColorColumn = { bg = c.bg_highlight },

    LineNr = { fg = c.fg },
    CursorLineNr = { fg = c.keyword },
    LineNrAbove = { link = "LineNr" },
    LineNrBelow = { link = "LineNr" },
    SignColumn = { fg = c.fg_dark, bg = c.bg },
    FoldColumn = { fg = c.fg_dark, bg = c.bg },
    Folded = { fg = c.comment, bg = c.grey_dark },

    Visual = { bg = c.bg_visual },
    VisualNOS = { bg = c.bg_visual },
    Search = { fg = c.fg_bright, bg = c.bg_search },
    IncSearch = { fg = c.bg, bg = c.bg_search_cur },
    CurSearch = { fg = c.bg, bg = c.bg_search_cur },
    Substitute = { fg = c.bg, bg = c.red },
    MatchParen = { fg = c.green_bright, bold = true },

    StatusLine = { fg = c.fg_dim, bg = c.bg_highlight },
    StatusLineNC = { fg = c.fg_dark, bg = c.bg_dark },
    WinBar = { fg = c.fg_dim, bg = c.none },
    WinBarNC = { fg = c.fg_dark, bg = c.none },
    WinSeparator = { fg = c.grey_dark },
    VertSplit = { link = "WinSeparator" },

    TabLine = { fg = c.fg_dark, bg = c.bg_dark },
    TabLineSel = { fg = c.fg, bg = c.bg_highlight },
    TabLineFill = { bg = c.bg_dark },

    Pmenu = { fg = c.fg, bg = c.bg_float },
    PmenuSel = { fg = c.fg_bright, bg = c.bg_visual },
    PmenuKind = { fg = c.keyword, bg = c.bg_float },
    PmenuKindSel = { fg = c.keyword, bg = c.bg_visual },
    PmenuExtra = { fg = c.comment, bg = c.bg_float },
    PmenuExtraSel = { fg = c.comment, bg = c.bg_visual },
    PmenuSbar = { bg = c.grey_dark },
    PmenuThumb = { bg = c.grey },
    WildMenu = { link = "PmenuSel" },

    Directory = { fg = c.keyword },
    Title = { fg = c.fg_bright },
    Question = { fg = c.green },
    MoreMsg = { fg = c.green },
    ModeMsg = { fg = c.fg_bright },
    ErrorMsg = { fg = c.red },
    WarningMsg = { fg = c.keyword },
    MsgArea = { fg = c.fg },
    MsgSeparator = { fg = c.grey_dark },
    NonText = { fg = c.grey_dark },
    Whitespace = { fg = c.grey_dark },
    SpecialKey = { fg = c.grey },
    EndOfBuffer = { fg = c.bg },
    Conceal = { fg = c.grey },
    QuickFixLine = { bg = c.bg_highlight },
    debugPC = { bg = c.bg_highlight },
    debugBreakpoint = { fg = c.red },

    SpellBad = { sp = c.red, undercurl = true },
    SpellCap = { sp = c.keyword, undercurl = true },
    SpellLocal = { sp = c.cyan, undercurl = true },
    SpellRare = { sp = c.magenta, undercurl = true },

    -- ==================================================================
    -- Syntax (legacy vim groups)
    -- ==================================================================
    Comment = style({ fg = c.comment }, styles.comments),

    Constant = { fg = c.string },
    String = { fg = c.string },
    Character = { fg = c.string },
    Boolean = { fg = c.string },
    -- Numeric literals share the string colour: everything that is a literal
    -- value reads as one category.
    Number = { fg = c.string },
    Float = { fg = c.string },

    Identifier = style({ fg = c.fg }, styles.variables),
    Function = style({ fg = fn_fg }, styles.functions),

    Statement = style({ fg = c.keyword }, styles.keywords),
    Conditional = style({ fg = c.keyword }, styles.keywords),
    Repeat = style({ fg = c.keyword }, styles.keywords),
    Label = style({ fg = c.keyword }, styles.keywords),
    Operator = { fg = c.fg },
    Keyword = style({ fg = c.keyword }, styles.keywords),
    Exception = style({ fg = c.keyword }, styles.keywords),

    -- Directives take the plain foreground, not the keyword goldenrod, which
    -- is reserved for keywords and types. `#define` and `#if` sit at the same
    -- level as ordinary text.
    PreProc = { fg = c.fg },
    Include = { fg = c.fg },
    Define = { fg = c.fg },
    PreCondit = { fg = c.fg },
    Macro = { fg = c.keyword },

    Type = style({ fg = type_fg }, styles.types),
    StorageClass = style({ fg = c.keyword }, styles.keywords),
    Structure = style({ fg = type_fg }, styles.types),
    Typedef = style({ fg = type_fg }, styles.types),

    Special = { fg = c.fg_dim },
    SpecialChar = { fg = c.orange },
    Tag = { fg = c.keyword },
    Delimiter = { fg = c.fg_dim },
    SpecialComment = { fg = c.grey_light },
    Debug = { fg = c.red },

    Underlined = { underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Ignore = { fg = c.grey },
    Error = { fg = c.red },
    Todo = { fg = c.bg, bg = c.keyword, bold = true },

    -- ==================================================================
    -- Diagnostics
    -- ==================================================================
    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.keyword },
    DiagnosticInfo = { fg = c.cyan },
    DiagnosticHint = { fg = c.green },
    DiagnosticOk = { fg = c.green },
    DiagnosticUnderlineError = { sp = c.red, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.keyword, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.cyan, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.green, undercurl = true },
    DiagnosticUnderlineOk = { sp = c.green, undercurl = true },
    DiagnosticVirtualTextError = { fg = c.red, bg = c.diff_delete },
    DiagnosticVirtualTextWarn = { fg = c.keyword, bg = c.diff_change },
    DiagnosticVirtualTextInfo = { fg = c.cyan, bg = c.bg_highlight },
    DiagnosticVirtualTextHint = { fg = c.green, bg = c.bg_highlight },
    DiagnosticVirtualTextOk = { fg = c.green, bg = c.bg_highlight },
    DiagnosticFloatingError = { fg = c.red, bg = c.bg_float },
    DiagnosticFloatingWarn = { fg = c.keyword, bg = c.bg_float },
    DiagnosticFloatingInfo = { fg = c.cyan, bg = c.bg_float },
    DiagnosticFloatingHint = { fg = c.green, bg = c.bg_float },
    DiagnosticFloatingOk = { fg = c.green, bg = c.bg_float },
    DiagnosticSignError = { fg = c.red },
    DiagnosticSignWarn = { fg = c.keyword },
    DiagnosticSignInfo = { fg = c.cyan },
    DiagnosticSignHint = { fg = c.green },
    DiagnosticSignOk = { fg = c.green },
    DiagnosticDeprecated = { fg = c.comment, strikethrough = true },
    DiagnosticUnnecessary = { fg = c.comment },

    -- ==================================================================
    -- LSP
    -- ==================================================================
    LspReferenceText = { bg = c.bg_highlight },
    LspReferenceRead = { bg = c.bg_highlight },
    LspReferenceWrite = { bg = c.bg_highlight },
    LspSignatureActiveParameter = { fg = c.fg_bright, bold = true },
    LspCodeLens = { fg = c.comment },
    LspCodeLensSeparator = { fg = c.grey_dark },
    LspInlayHint = { fg = c.fg_dark, bg = c.bg_highlight },

    -- Semantic tokens. Kept aligned with the flat look on purpose.
    ["@lsp.type.class"] = { link = "Type" },
    ["@lsp.type.comment"] = {},
    ["@lsp.type.decorator"] = { link = "Function" },
    ["@lsp.type.enum"] = { link = "Type" },
    ["@lsp.type.enumMember"] = { link = "Constant" },
    ["@lsp.type.function"] = { link = "Function" },
    ["@lsp.type.interface"] = { link = "Type" },
    ["@lsp.type.macro"] = { link = "Macro" },
    -- Roslyn emits these for C# preprocessor directives. Semantic tokens
    -- outrank Treesitter, so without them `#if` / `#endif` lose the goldenrod
    -- that PreProc and @keyword.directive would otherwise give them.
    ["@lsp.type.preprocessorKeyword"] = { link = "PreProc" },
    ["@lsp.type.preprocessorText"] = { fg = c.fg },
    ["@lsp.type.method"] = { link = "Function" },
    ["@lsp.type.namespace"] = { link = "Identifier" },
    ["@lsp.type.parameter"] = { link = "Identifier" },
    ["@lsp.type.property"] = { link = "Identifier" },
    ["@lsp.type.struct"] = { link = "Type" },
    ["@lsp.type.type"] = { link = "Type" },
    ["@lsp.type.typeParameter"] = { link = "Type" },
    ["@lsp.type.variable"] = { link = "Identifier" },
    ["@lsp.type.keyword"] = { link = "Keyword" },
    ["@lsp.type.string"] = { link = "String" },
    ["@lsp.type.number"] = { link = "Number" },
    ["@lsp.type.operator"] = { link = "Operator" },
    ["@lsp.mod.deprecated"] = { strikethrough = true },

    -- ==================================================================
    -- Treesitter
    -- ==================================================================
    ["@variable"] = style({ fg = c.fg }, styles.variables),
    ["@variable.builtin"] = { fg = c.keyword },
    ["@variable.parameter"] = { fg = c.fg },
    ["@variable.parameter.builtin"] = { fg = c.keyword },
    ["@variable.member"] = { fg = c.fg },

    ["@constant"] = { fg = c.string },
    ["@constant.builtin"] = { fg = c.string },
    ["@constant.macro"] = { fg = c.keyword },

    ["@module"] = { fg = c.fg },
    ["@module.builtin"] = { fg = c.keyword },
    ["@label"] = { fg = c.keyword },

    ["@string"] = { fg = c.string },
    ["@string.documentation"] = { fg = c.string },
    ["@string.regexp"] = { fg = c.orange },
    ["@string.escape"] = { fg = c.orange },
    ["@string.special"] = { fg = c.orange },
    ["@string.special.symbol"] = { fg = c.fg },
    ["@string.special.url"] = { fg = c.cyan, underline = true },
    ["@string.special.path"] = { fg = c.string },

    ["@character"] = { fg = c.string },
    ["@character.special"] = { fg = c.orange },
    ["@boolean"] = { fg = c.string },
    ["@number"] = { fg = c.string },
    ["@number.float"] = { fg = c.string },

    ["@type"] = style({ fg = type_fg }, styles.types),
    ["@type.builtin"] = style({ fg = type_fg }, styles.types),
    ["@type.definition"] = style({ fg = type_fg }, styles.types),

    ["@attribute"] = { fg = c.keyword },
    ["@attribute.builtin"] = { fg = c.keyword },
    ["@property"] = { fg = c.fg },

    ["@function"] = style({ fg = fn_fg }, styles.functions),
    ["@function.builtin"] = style({ fg = fn_fg }, styles.functions),
    ["@function.call"] = style({ fg = fn_fg }, styles.functions),
    ["@function.macro"] = { fg = c.keyword },
    ["@function.method"] = style({ fg = fn_fg }, styles.functions),
    ["@function.method.call"] = style({ fg = fn_fg }, styles.functions),
    ["@constructor"] = { fg = type_fg },
    ["@operator"] = { fg = c.fg },

    ["@keyword"] = style({ fg = c.keyword }, styles.keywords),
    ["@keyword.coroutine"] = style({ fg = c.keyword }, styles.keywords),
    ["@keyword.function"] = style({ fg = c.keyword }, styles.keywords),
    ["@keyword.operator"] = style({ fg = c.keyword }, styles.keywords),
    ["@keyword.import"] = style({ fg = c.keyword }, styles.keywords),
    ["@keyword.type"] = style({ fg = c.keyword }, styles.keywords),
    ["@keyword.modifier"] = style({ fg = c.keyword }, styles.keywords),
    ["@keyword.repeat"] = style({ fg = c.keyword }, styles.keywords),
    ["@keyword.return"] = style({ fg = c.keyword }, styles.keywords),
    ["@keyword.debug"] = { fg = c.red },
    ["@keyword.exception"] = style({ fg = c.keyword }, styles.keywords),
    ["@keyword.conditional"] = style({ fg = c.keyword }, styles.keywords),
    ["@keyword.conditional.ternary"] = { fg = c.fg },
    ["@keyword.directive"] = { fg = c.fg },
    ["@keyword.directive.define"] = { fg = c.fg },
    -- Older queries (and several parsers) still capture directives as
    -- @preproc rather than @keyword.directive.
    ["@preproc"] = { fg = c.fg },
    ["@define"] = { fg = c.fg },
    ["@include"] = { fg = c.fg },

    ["@punctuation.delimiter"] = { fg = c.fg_dim },
    ["@punctuation.bracket"] = { fg = c.fg_dim },
    ["@punctuation.special"] = { fg = c.orange },

    ["@comment"] = style({ fg = c.comment }, styles.comments),
    ["@comment.documentation"] = style({ fg = c.comment }, styles.comments),

    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.heading"] = { fg = c.keyword, bold = true },
    ["@markup.heading.1"] = { fg = c.keyword, bold = true },
    ["@markup.heading.2"] = { fg = c.fg_bright, bold = true },
    ["@markup.heading.3"] = { fg = c.fg, bold = true },
    ["@markup.heading.4"] = { fg = c.fg_dim, bold = true },
    ["@markup.heading.5"] = { fg = c.fg_dim },
    ["@markup.heading.6"] = { fg = c.fg_dark },
    ["@markup.quote"] = { fg = c.comment },
    ["@markup.math"] = { fg = c.cyan },
    ["@markup.link"] = { fg = c.cyan },
    ["@markup.link.label"] = { fg = c.cyan },
    ["@markup.link.url"] = { fg = c.cyan, underline = true },
    ["@markup.raw"] = { fg = c.string },
    ["@markup.raw.block"] = { fg = c.string },
    ["@markup.list"] = { fg = c.keyword },
    ["@markup.list.checked"] = { fg = c.green },
    ["@markup.list.unchecked"] = { fg = c.fg_dark },

    ["@diff.plus"] = { fg = c.green },
    ["@diff.minus"] = { fg = c.red },
    ["@diff.delta"] = { fg = c.keyword },

    ["@tag"] = { fg = c.keyword },
    ["@tag.builtin"] = { fg = c.keyword },
    ["@tag.attribute"] = { fg = c.fg },
    ["@tag.delimiter"] = { fg = c.fg_dim },

    -- ==================================================================
    -- Diffs
    -- ==================================================================
    DiffAdd = { bg = c.diff_add },
    DiffChange = { bg = c.diff_change },
    DiffDelete = { bg = c.diff_delete },
    DiffText = { bg = c.diff_text },
    diffAdded = { fg = c.green },
    diffRemoved = { fg = c.red },
    diffChanged = { fg = c.keyword },
    diffOldFile = { fg = c.red },
    diffNewFile = { fg = c.green },
    diffFile = { fg = c.fg_dim },
    diffLine = { fg = c.comment },
    diffIndexLine = { fg = c.comment },

    -- ==================================================================
    -- Plugins
    -- ==================================================================
    -- gitsigns
    GitSignsAdd = { fg = c.green },
    GitSignsChange = { fg = c.keyword },
    GitSignsDelete = { fg = c.red },
    GitSignsAddInline = { bg = c.diff_add },
    GitSignsChangeInline = { bg = c.diff_text },
    GitSignsDeleteInline = { bg = c.diff_delete },
    GitSignsCurrentLineBlame = { fg = c.fg_dark },

    -- telescope
    TelescopeNormal = { fg = c.fg, bg = c.bg_float },
    TelescopeBorder = { fg = c.grey, bg = c.bg_float },
    TelescopeTitle = { fg = c.keyword },
    TelescopePromptNormal = { fg = c.fg, bg = c.bg_highlight },
    TelescopePromptBorder = { fg = c.grey, bg = c.bg_highlight },
    TelescopePromptTitle = { fg = c.bg, bg = c.keyword },
    TelescopePromptPrefix = { fg = c.keyword },
    TelescopeResultsTitle = { fg = c.fg_dim },
    TelescopePreviewTitle = { fg = c.fg_dim },
    TelescopeSelection = { fg = c.fg_bright, bg = c.bg_visual },
    TelescopeSelectionCaret = { fg = c.keyword, bg = c.bg_visual },
    TelescopeMatching = { fg = c.green_bright, bold = true },
    TelescopeMultiSelection = { fg = c.orange },

    -- nvim-cmp / blink.cmp
    CmpItemAbbr = { fg = c.fg },
    CmpItemAbbrDeprecated = { fg = c.comment, strikethrough = true },
    CmpItemAbbrMatch = { fg = c.fg_bright, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.fg_bright },
    CmpItemMenu = { fg = c.comment },
    CmpItemKind = { fg = c.keyword },
    CmpItemKindFunction = { fg = fn_fg },
    CmpItemKindMethod = { fg = fn_fg },
    CmpItemKindVariable = { fg = c.fg },
    CmpItemKindKeyword = { fg = c.keyword },
    CmpItemKindText = { fg = c.fg_dim },
    CmpItemKindSnippet = { fg = c.string },
    CmpItemKindClass = { fg = type_fg },
    CmpItemKindStruct = { fg = type_fg },
    CmpItemKindInterface = { fg = type_fg },
    BlinkCmpMenu = { fg = c.fg, bg = c.bg_float },
    BlinkCmpMenuBorder = { fg = c.grey, bg = c.bg_float },
    BlinkCmpMenuSelection = { fg = c.fg_bright, bg = c.bg_visual },
    BlinkCmpLabelMatch = { fg = c.fg_bright, bold = true },
    BlinkCmpLabelDeprecated = { fg = c.comment, strikethrough = true },
    BlinkCmpKind = { fg = c.keyword },
    BlinkCmpDoc = { fg = c.fg, bg = c.bg_float },
    BlinkCmpDocBorder = { fg = c.grey, bg = c.bg_float },
    BlinkCmpSignatureHelp = { fg = c.fg, bg = c.bg_float },
    BlinkCmpSignatureHelpActiveParameter = { fg = c.fg_bright, bold = true },

    -- nvim-tree
    NvimTreeNormal = { fg = c.fg, bg = c.bg_dark },
    NvimTreeNormalNC = { fg = c.fg, bg = c.bg_dark },
    NvimTreeWinSeparator = { fg = c.grey_dark, bg = c.bg_dark },
    NvimTreeRootFolder = { fg = c.keyword, bold = true },
    NvimTreeFolderName = { fg = c.fg },
    NvimTreeFolderIcon = { fg = c.keyword },
    NvimTreeOpenedFolderName = { fg = c.fg_bright },
    NvimTreeEmptyFolderName = { fg = c.fg_dark },
    NvimTreeSpecialFile = { fg = c.orange },
    NvimTreeGitDirty = { fg = c.keyword },
    NvimTreeGitNew = { fg = c.green },
    NvimTreeGitDeleted = { fg = c.red },
    NvimTreeIndentMarker = { fg = c.grey_dark },
    NvimTreeCursorLine = { bg = c.bg_highlight },

    -- neo-tree
    NeoTreeNormal = { fg = c.fg, bg = c.bg_dark },
    NeoTreeNormalNC = { fg = c.fg, bg = c.bg_dark },
    NeoTreeWinSeparator = { fg = c.grey_dark, bg = c.bg_dark },
    NeoTreeRootName = { fg = c.keyword, bold = true },
    NeoTreeDirectoryName = { fg = c.fg },
    NeoTreeDirectoryIcon = { fg = c.keyword },
    NeoTreeFileName = { fg = c.fg },
    NeoTreeFileNameOpened = { fg = c.fg_bright },
    NeoTreeIndentMarker = { fg = c.grey_dark },
    NeoTreeGitAdded = { fg = c.green },
    NeoTreeGitModified = { fg = c.keyword },
    NeoTreeGitDeleted = { fg = c.red },
    NeoTreeGitUntracked = { fg = c.fg_dark },
    NeoTreeDimText = { fg = c.fg_dark },

    -- which-key
    WhichKey = { fg = c.keyword },
    WhichKeyGroup = { fg = c.fg },
    WhichKeyDesc = { fg = c.fg_dim },
    WhichKeySeparator = { fg = c.comment },
    WhichKeyFloat = { bg = c.bg_float },
    WhichKeyBorder = { fg = c.grey, bg = c.bg_float },
    WhichKeyValue = { fg = c.comment },

    -- indent-blankline
    IblIndent = { fg = c.grey_dark },
    IblScope = { fg = c.grey },
    IblWhitespace = { fg = c.grey_dark },

    -- mini.nvim
    MiniIndentscopeSymbol = { fg = c.grey },
    MiniStatuslineModeNormal = { fg = c.bg, bg = c.keyword, bold = true },
    MiniStatuslineModeInsert = { fg = c.bg, bg = c.green, bold = true },
    MiniStatuslineModeVisual = { fg = c.bg, bg = c.blue, bold = true },
    MiniStatuslineModeReplace = { fg = c.bg, bg = c.red, bold = true },
    MiniStatuslineModeCommand = { fg = c.bg, bg = c.orange, bold = true },
    MiniStatuslineDevinfo = { fg = c.fg_dim, bg = c.bg_highlight },
    MiniStatuslineFilename = { fg = c.fg, bg = c.bg_highlight },
    MiniStatuslineInactive = { fg = c.fg_dark, bg = c.bg_dark },

    -- nvim-notify
    NotifyERRORBorder = { fg = c.red },
    NotifyWARNBorder = { fg = c.keyword },
    NotifyINFOBorder = { fg = c.cyan },
    NotifyDEBUGBorder = { fg = c.grey },
    NotifyTRACEBorder = { fg = c.magenta },
    NotifyERRORIcon = { fg = c.red },
    NotifyWARNIcon = { fg = c.keyword },
    NotifyINFOIcon = { fg = c.cyan },
    NotifyDEBUGIcon = { fg = c.grey },
    NotifyTRACEIcon = { fg = c.magenta },
    NotifyERRORTitle = { fg = c.red },
    NotifyWARNTitle = { fg = c.keyword },
    NotifyINFOTitle = { fg = c.cyan },
    NotifyDEBUGTitle = { fg = c.grey },
    NotifyTRACETitle = { fg = c.magenta },

    -- lazy.nvim
    LazyNormal = { fg = c.fg, bg = c.bg_float },
    LazyButton = { fg = c.fg, bg = c.bg_highlight },
    LazyButtonActive = { fg = c.bg, bg = c.keyword },
    LazyH1 = { fg = c.bg, bg = c.keyword, bold = true },
    LazyH2 = { fg = c.keyword, bold = true },
    LazySpecial = { fg = c.keyword },
    LazyProgressDone = { fg = c.green },
    LazyProgressTodo = { fg = c.grey_dark },
    LazyCommit = { fg = c.string },
    LazyReasonPlugin = { fg = c.orange },

    -- flash.nvim / leap / hop
    FlashLabel = { fg = c.bg, bg = c.green_bright, bold = true },
    FlashMatch = { fg = c.fg_bright, bg = c.bg_search },
    FlashCurrent = { fg = c.bg, bg = c.bg_search_cur },
    LeapLabelPrimary = { fg = c.bg, bg = c.green_bright, bold = true },
    LeapLabelSecondary = { fg = c.bg, bg = c.keyword, bold = true },
    LeapMatch = { fg = c.fg_bright, bold = true },
    HopNextKey = { fg = c.green_bright, bold = true },
    HopNextKey1 = { fg = c.keyword, bold = true },
    HopNextKey2 = { fg = c.orange },
    HopUnmatched = { fg = c.grey },

    -- render-markdown / headlines
    RenderMarkdownH1Bg = { fg = c.keyword, bg = c.bg_highlight },
    RenderMarkdownH2Bg = { fg = c.fg_bright, bg = c.bg_highlight },
    RenderMarkdownH3Bg = { fg = c.fg, bg = c.bg_highlight },
    RenderMarkdownCode = { bg = c.bg_dark },
    RenderMarkdownBullet = { fg = c.keyword },

    -- fzf-lua
    FzfLuaNormal = { fg = c.fg, bg = c.bg_float },
    FzfLuaBorder = { fg = c.grey, bg = c.bg_float },
    FzfLuaTitle = { fg = c.keyword },
    FzfLuaCursorLine = { bg = c.bg_visual },
    FzfLuaFzfMatch = { fg = c.green_bright },
  }

  -- TODO / NOTE / IMPORTANT style keywords.
  if config.comment_keywords then
    hl.MuraboxTodo = { fg = c.bg, bg = c.keyword, bold = true }
    hl.MuraboxNote = { fg = c.bg, bg = c.green, bold = true }
    hl.MuraboxImportant = { fg = c.bg, bg = c.red, bold = true }
    hl.MuraboxStudy = { fg = c.bg, bg = c.cyan, bold = true }

    -- todo-comments.nvim
    hl.TodoBgTODO = { fg = c.bg, bg = c.keyword, bold = true }
    hl.TodoFgTODO = { fg = c.keyword }
    hl.TodoSignTODO = { fg = c.keyword }
    hl.TodoBgNOTE = { fg = c.bg, bg = c.green, bold = true }
    hl.TodoFgNOTE = { fg = c.green }
    hl.TodoSignNOTE = { fg = c.green }
    hl.TodoBgFIX = { fg = c.bg, bg = c.red, bold = true }
    hl.TodoFgFIX = { fg = c.red }
    hl.TodoSignFIX = { fg = c.red }
    hl.TodoBgWARN = { fg = c.bg, bg = c.orange, bold = true }
    hl.TodoFgWARN = { fg = c.orange }
    hl.TodoSignWARN = { fg = c.orange }
    hl.TodoBgHACK = { fg = c.bg, bg = c.orange, bold = true }
    hl.TodoFgHACK = { fg = c.orange }
    hl.TodoSignHACK = { fg = c.orange }
    hl.TodoBgPERF = { fg = c.bg, bg = c.magenta, bold = true }
    hl.TodoFgPERF = { fg = c.magenta }
    hl.TodoSignPERF = { fg = c.magenta }
  end

  -- User overrides.
  local overrides = config.highlights
  if type(overrides) == "function" then
    overrides(hl, c)
  elseif type(overrides) == "table" then
    for group, spec in pairs(overrides) do
      hl[group] = spec
    end
  end

  return hl
end

return M
