local lazy = require "lazy"
return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  "nvim-lua/plenary.nvim",

  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end,
  },

  {
    "nvchad/base46",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  "nvzone/volt",

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- ensure_installed = 'all',
      ignore_install = { "org" },
    },
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },

  {
    "stevearc/conform.nvim",
    --  for users those who want auto-save conform + lazyloading!
    -- event = "BufWritePre"
    config = function()
      require "configs.conform"
    end,
  },

  -- LeetCode in Neovim
  -- {
  --     "kawre/leetcode.nvim",
  --     lazy = false,
  --     build = ":TSUpdate html",
  --     dependencies = {
  --       "nvim-telescope/telescope.nvim",
  --       "nvim-lua/plenary.nvim", -- required by telescope
  --       "MunifTanjim/nui.nvim",
  --       "rcarriga/nvim-notify",
  --
  --       -- optional
  --       "nvim-treesitter/nvim-treesitter",
  --       "nvim-tree/nvim-web-devicons",
  --     },
  --     keys = {
  --       { "<leader>lq", mode = { "n" }, "<cmd>Leet tabs<cr>" },
  --       { "<leader>lm", mode = { "n" }, "<cmd>Leet menu<cr>" },
  --       { "<leader>lc", mode = { "n" }, "<cmd>Leet console<cr>" },
  --       { "<leader>li", mode = { "n" }, "<cmd>Leet info<cr>" },
  --       { "<leader>ll", mode = { "n" }, "<cmd>Leet lang<cr>" },
  --       { "<leader>ld", mode = { "n" }, "<cmd>Leet desc<cr>" },
  --       { "<leader>lr", mode = { "n" }, "<cmd>Leet run<cr>" },
  --       { "<leader>ls", mode = { "n" }, "<cmd>Leet submit<cr>" },
  --       { "<leader>ly", mode = { "n" }, "<cmd>Leet yank<cr>" },
  --       { "<leader>lp", mode = { "n" }, "<cmd>Leet list<cr>" },
  --     },
  --     config = function()
  --       require "custom.configs.leetcode"
  --     end,
  --   },

  -- Codeforces in Neovim
  {
    "xeluxee/competitest.nvim",
    lazy = false,
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require "configs.competitest"
    end,
  },

  -- Github Copilot in Neovim
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup {
  --       panel = {
  --         enabled = true,
  --         auto_refresh = true,
  --         keymap = {
  --           jump_prev = "[[",
  --           jump_next = "]]",
  --           accept = "<CR>",
  --           refresh = "gr",
  --           open = "<M-CR>",
  --         },
  --         layout = {
  --           position = "bottom", -- | top | left | right
  --           ratio = 0.4,
  --         },
  --       },
  --       suggestion = {
  --         enabled = true,
  --         auto_trigger = true,
  --         debounce = 75,
  --         keymap = {
  --           accept = "<C-j>",
  --           accept_word = false,
  --           accept_line = false,
  --           -- next = "<M-]>",
  --           -- prev = "<M-[>",
  --           dismiss = "<C-]>",
  --         },
  --       },
  --       filetypes = {
  --         yaml = false,
  --         markdown = false,
  --         help = false,
  --         gitcommit = false,
  --         gitrebase = false,
  --         hgcommit = false,
  --         svn = false,
  --         cvs = false,
  --         ["."] = false,
  --       },
  --       copilot_node_command = "node", -- Node.js version must be > 18.x
  --       server_opts_overrides = {},
  --     }
  --   end,
  -- },

  -- Codeium in Neovim
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    -- config = function()
    --   -- vim.g.codeium_disable_bindings = 1
    --   vim.g.codeium_enabled = true
    --   vim.g.codeium_filetypes_disabled_by_default = true
    --   vim.g.codeium_filetypes = {
    --   }
    -- end,

    -- config = function ()
    --     -- Change '<C-g>' here to any keycode you like.
    --     vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
    --     vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
    --     vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
    --     vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    --   end

    -- Clear current suggestion 	codeium#Clear() 	<C-]>
    -- Next suggestion 	codeium#CycleCompletions(1) 	<M-]>
    -- Previous suggestion 	codeium#CycleCompletions(-1) 	<M-[>
    -- Insert suggestion 	codeium#Accept() 	<Tab>
    -- Manually trigger suggestion 	codeium#Complete() 	<M-Bslash>
    -- Accept word from suggestion 	codeium#AcceptNextWord() 	<C-k>
    -- Accept line from suggestion 	codeium#AcceptNextLine() 	<C-l>
  },

  -- Latex Compilation in Neovim
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura"
      -- vim.g.vimtex_view_method = "okular"
      vim.g.vimtex_syntax_enabled = 1
    end,
  },

  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      -- Setup orgmode
      require("orgmode").setup {
        org_agenda_files = "/mnt/Karna/Git/Project-K/Org/**/*",
        org_default_notes_file = "/mnt/Karna/Git/Project-K/Org/notes.org",
      }

      -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
      -- add ~org~ to ignore_install
      -- require('nvim-treesitter.configs').setup({
      --   ensure_installed = 'all',
      --   ignore_install = { 'org' },
      -- })
    end,
  },

  -- https://nvimdev.github.io/lspsaga/
  {
    "nvimdev/lspsaga.nvim",
    lazy = false,
    event = "LspAttach",
    config = function()
      require("lspsaga").setup {}
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    commit = "29be0919b91fb59eca9e90690d76014233392bef",
    opts = {},
    config = function()
      require "configs.ibl"
    end,
  },

  -- Alt Dashboard
  -- {
  --     "nvimdev/dashboard-nvim",
  --     event = "VimEnter",
  --     config = function()
  --       require("dashboard").setup {
  --         -- config
  --       }
  --       require "configs.dashboard-nvim"
  --     end,
  --     dependencies = { { "nvim-tree/nvim-web-devicons" } },
  --   },

  -- Wakatime for Neovim

  { "wakatime/vim-wakatime", lazy = false },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require "configs.zen-mode"
    end,
  },

  {
    "mg979/vim-visual-multi",
    lazy = false,
  },

 -- MultiCursors for Neovim
  -- {
  --   "smoka7/multicursors.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "smoka7/hydra.nvim",
  --   },
  --   opts = {},
  --   cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  --   keys = {
  --     {
  --       mode = { "v", "n" },
  --       "<Leader>m",
  --       "<cmd>MCstart<cr>",
  --       desc = "Create a selection for selected text or word under the cursor",
  --     },
  --   },
  -- },

  -- Ollama in Neovim

  -- {
  --    "David-Kunz/gen.nvim",
  --    lazy = false,
  --    opts = {
  --      model = "mistral", -- The default model to use.
  --      host = "localhost", -- The host running the Ollama service.
  --      port = "11434", -- The port on which the Ollama service is listening.
  --      display_mode = "float", -- The display mode. Can be "float" or "split".
  --      show_prompt = false, -- Shows the Prompt submitted to Ollama.
  --      show_model = false, -- Displays which model you are using at the beginning of your chat session.
  --      no_auto_close = false, -- Never closes the window automatically.
  --      init = function(options)
  --        pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
  --      end,
  --      -- Function to initialize Ollama
  --      command = function(options)
  --        return "curl --silent --no-buffer -X POST http://"
  --          .. options.host
  --          .. ":"
  --          .. options.port
  --          .. "/api/chat -d $body"
  --      end,
  --      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
  --      -- This can also be a command string.
  --      -- The executed command must return a JSON object with { response, context }
  --      -- (context property is optional).
  --      -- list_models = '<omitted lua function>', -- Retrieves a list of model names
  --      debug = false, -- Prints errors and the command which is run.
  --    },
  --    -- require('gen').select_model()
  --  },

{
    -- Hints keybinds
    'folke/which-key.nvim',
    opts = {
      -- win = {
      --   border = {
      --     { '┌', 'FloatBorder' },
      --     { '─', 'FloatBorder' },
      --     { '┐', 'FloatBorder' },
      --     { '│', 'FloatBorder' },
      --     { '┘', 'FloatBorder' },
      --     { '─', 'FloatBorder' },
      --     { '└', 'FloatBorder' },
      --     { '│', 'FloatBorder' },
      --   },
      -- },
    },
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- high-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    "navarasu/onedark.nvim",
    priority = 1000,
  },
}
