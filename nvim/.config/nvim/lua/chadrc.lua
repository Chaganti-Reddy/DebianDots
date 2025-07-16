-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox",
  transparency = true,
  hl_add = {
    NvimTreeOpenedFolderName = { fg = "green", bold = true },
  },

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
  integrations = {},
  -- changed_themes = {},
  theme_toggle = { "gruvbox", "gruvbox_light" },
}

-- M.nvdash = {
--   load_on_startup = true,
--   header = {
--     "                            ",
--     "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
--     "   ▄▀███▄     ▄██ █████▀    ",
--     "   ██▄▀███▄   ███           ",
--     "   ███  ▀███▄ ███           ",
--     "   ███    ▀██ ███           ",
--     "   ███      ▀ ███           ",
--     "   ▀██ █████▄▀█▀▄██████▄    ",
--     "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
--     "                            ",
--     "     Powered By  eovim    ",
--     "                            ",
--   },
--
--   buttons = {
--     { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
--     { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
--     { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
--     { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
--     { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
--     { txt = "  Quit NVIM", keys = "qq", cmd = ":qa" },
--
--     { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
--
--     {
--       txt = function()
--         local stats = require("lazy").stats()
--         local ms = math.floor(stats.startuptime) .. " ms"
--         return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
--       end,
--       hl = "NvDashFooter",
--       no_gap = true,
--     },
--
--     { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
--   },
--
-- }
--

M.nvdash = {
  load_on_startup = true,
  header = {
    "                            ",
    "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
    "   ▄▀███▄     ▄██ █████▀    ",
    "   ██▄▀███▄   ███           ",
    "   ███  ▀███▄ ███           ",
    "   ███    ▀██ ███           ",
    "   ███      ▀ ███           ",
    "   ▀██ █████▄▀█▀▄██████▄    ",
    "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
    "                            ",
    "     Powered By  eovim    ",
    "                            ",
  },

  buttons = {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
    { txt = "  Recent Files", keys = "fr", cmd = "Telescope oldfiles" },
    { txt = "  Favourites", keys = "fd", cmd = ":lua QuickAccessMenu()" },
    { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
    { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
    { txt = "  Quit NVIM", keys = "qq", cmd = ":qa" },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
}

-- Lua Function for Quick Access Menu
function QuickAccessMenu()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "Quick Access",
    finder = finders.new_table({
      results = {
        { "Dotfiles", "~/dotfiles" },
        { "Hyprland Configs", "~/.config/hypr/" },
        { "Nvim Config", "~/.config/nvim/lua/" },
        { "Portfolio", "/mnt/Karna/Git/portfolio/" },
      },
      entry_maker = function(entry)
        return {
          value = entry[2],
          display = entry[1],
          ordinal = entry[1],
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local function open_dir()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("cd " .. selection.value)
        vim.cmd("Telescope find_files")
      end

      map("i", "<CR>", open_dir)
      map("n", "<CR>", open_dir)
      return true
    end,
  }):find()
end



M.ui = {
  tabufline = {
    enabled = true,
    lazyload = false,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    modules = nil,
  },

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default",                  -- default/flat_light/flat_dark/atom/atom_colored
  },
  telescope = { style = "borderless" }, -- borderless
  statusline = {
    theme = "vscode",                   -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "default",
    order = nil,
    modules = nil,
  },
  term = {
    winopts = { number = false, relativenumber = false },
    sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },
  lsp = { signature = true },

  cheatsheet = {
    theme = "grid", -- simple/grid
    -- excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
  },

  mason = { cmd = true, pkgs = {} },
}

return M
