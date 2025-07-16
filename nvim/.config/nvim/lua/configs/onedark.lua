-- lua/configs/onedark.lua

local M = {}

local config = {
  style = "dark",
  transparent = true,
  term_colors = true,
  ending_tildes = false,
  cmp_itemkind_reverse = false,
  code_style = {
    comments = "italic",
    keywords = "none",
    functions = "none",
    strings = "none",
    variables = "none",
  },
  lualine = {
    transparent = false,
  },
  toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" },
  diagnostics = {
    darker = true,
    undercurl = true,
    background = true,
  },
}

local function set_diagnostics_bg_transparency()
  vim.cmd [[highlight DiagnosticVirtualTextError guibg=none]]
  vim.cmd [[highlight DiagnosticVirtualTextWarn guibg=none]]
  vim.cmd [[highlight DiagnosticVirtualTextInfo guibg=none]]
  vim.cmd [[highlight DiagnosticVirtualTextHint guibg=none]]
end

M.setup = function()
  local onedark = require("onedark")
  onedark.setup(config)
  onedark.load()
  set_diagnostics_bg_transparency()
end

M.toggle_transparency = function()
  local onedark = require("onedark")
  config.transparent = not config.transparent
  onedark.setup(config)
  onedark.load()
  set_diagnostics_bg_transparency()
end

return M
