return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Debugger UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',

    -- Debug adapters management
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Language-specific debuggers
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_setup = true,
      automatic_installation = true,
      ensure_installed = {
        'debugpy',      -- Python
        'cpptools',     -- C/C++
      },
    }

    -- Setup dap-ui
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Keymap for toggling dapui
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Python config
    require('dap-python').setup()

    -- C/C++ config
    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = vim.fn.stdpath("data") .. '/mason/bin/OpenDebugAD7',
      options = {
        detached = false
      }
    }

local gdb_path = vim.fn.exepath("gdb")  -- Finds the correct gdb path or empty string if not found

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
    MIMode = "gdb",
    miDebuggerPath = gdb_path,
  },
}
dap.configurations.c = dap.configurations.cpp

-- local lldb_path = vim.fn.exepath("lldb")  -- Usually /usr/bin/lldb
--
-- dap.configurations.cpp = {
--   {
--     name = "Launch file (LLDB)",
--     type = "cppdbg",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopAtEntry = true,
--     MIMode = "lldb",
--     miDebuggerPath = lldb_path,
--   },
-- }
-- dap.configurations.c = dap.configurations.cpp

  end,
}

