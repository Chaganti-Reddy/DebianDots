local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map({ "n", "i" }, "<C-a>", "<ESC>ggVG", { desc = "Select all text" })

-- multiple modes
-- map({ "i", "n" }, "<C-k>", "<Up>", { desc = "Move up" })
-- map({ "i", "n" }, "<C-j>", "<Down>", { desc = "Move down" })
-- map({ "i", "n" }, "<C-h>", "<Left>", { desc = "Move left" })
-- map({ "i", "n" }, "<C-l>", "<Right>", { desc = "Move right" })

-- Save and load session
vim.keymap.set('n', '<leader>ss', ':mksession! .session.vim<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>sl', ':source .session.vim<CR>', { noremap = true, silent = false })

-- Vimtex
map({ "n" }, "<leader>cc", ":VimtexCompile<CR>", { desc = "Compile vimtex" })
map({ "n" }, "<leader>cx", ":VimtexClean<CR>", { desc = "Clean vimtex" })
map({ "n" }, "<leader>co", ":VimtexView<CR>", { desc = "View vimtex" })
map({ "n" }, "<leader>csv", ":VimtexStop<CR>", { desc = "Stop vimtex" })

-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- Normal mode
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("n", "<A-Down>", ":m .+1<CR>==", opts)
map("n", "<A-Up>", ":m .-2<CR>==", opts)

-- Visual mode
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", opts)

-- Zen Mode
map("n", "<leader>z", ":ZenMode<CR>", { desc = "Toggle Zen Mode" })

-- Ollama
map("n", "<leader>gg", ":Gen<CR>", { desc = "Open Ollama" })


-- CompetiTest
map("n", "<leader>pr", ":CompetiTest run<CR>", { desc = "Competitest Run" })
map("n", "<leader>pa", ":CompetiTest receive testcases<CR>", { desc = "Competitest Receive Testcases" })
map("n", "<leader>pc", ":CompetiTest receive contest<CR>", { desc = "Competitest Receive Contest" })
map("n", "<leader>pp", ":CompetiTest receive problem<CR>", { desc = "Competitest Receive Problem" })
map("n", "<leader>pu", ":CompetiTest show_ui<CR>", { desc = "Competitest Show UI" })
map("n", "<leader>pd", ":CompetiTest delete_testcase<CR>", { desc = "Competitest Delete Testcase" })
map("n", "<leader>pA", ":CompetiTest add_testcase<CR>", { desc = "Competitest Add Testcase" })
map("n", "<leader>pe", ":CompetiTest edit_testcase<CR>", { desc = "Competitest Edit Testcase" })

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

vim.keymap.set('n', '<C-Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
-- vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<C-q>', ':bdelete<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>to', '<cmd> enew <CR>', opts) -- new buffer

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<C-x><Left>",  "<C-w>h", { desc = "Switch window left" })
map("n", "<C-x><Right>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-x><Down>",  "<C-w>j", { desc = "Switch window down" })
map("n", "<C-x><Up>",    "<C-w>k", { desc = "Switch window up" })

map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })
map("n", "<leader>se", ":wincmd =<CR>", { desc = "Equalize split sizes" })
map("n", "<leader>nf", ":e %:h/", { desc = "New file in current directory" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
-- map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

-- Comment
-- map("n", "<C-/>", "gcc", { desc = "toggle comment", remap = true })
map('n', '<C-/>', require('Comment.api').toggle.linewise.current, opts)
map('n', '<C-_>', require('Comment.api').toggle.linewise.current, opts)
map('v', '<C-/>', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
map('v', '<C-_>', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
-- map("v", "<C-/>", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical term" })

-- Helper: sanitize a path for use as an ID (no slashes, etc.)
local function dir_to_id(dir)
  return "term_" .. dir:gsub("[/\\]", "_")
end

-- The main toggle function
local function open_term_per_directory(opts)
  local dir = vim.fn.expand("%:p:h")
  if dir == nil or dir == "" or vim.fn.isdirectory(dir) ~= 1 then
    dir = vim.fn.getcwd()
  end

  local term_id = dir_to_id(dir)
  opts = vim.tbl_extend("force", opts or {}, { id = term_id })

  vim.cmd("lcd " .. dir)

  -- Set sensible defaults based on type
  if opts.pos == "float" then
    opts.float_opts = opts.float_opts or {
      row = 0.25,
      col = 0.2,
      width = 0.6,
      height = 0.4,
    }
    opts.size = nil -- do not use size for floats!
  elseif opts.pos == "vsp" or opts.pos == "vertical" then
    opts.size = opts.size or 0.4 -- 40% of editor width
    opts.float_opts = nil
  else -- "sp" or "horizontal"
    opts.size = opts.size or 0.4 -- 40% of editor height
    opts.float_opts = nil
  end

  require("nvchad.term").toggle(opts)
end

-- Horizontal split (40% of editor height)
map({ "n", "t" }, "<A-h>", function()
  open_term_per_directory { pos = "sp", size = 0.4 }
end, { desc = "terminal: toggleable horizontal term per dir" })

-- Vertical split (40% of editor width)
map({ "n", "t" }, "<A-v>", function()
  open_term_per_directory { pos = "vsp", size = 0.4 }
end, { desc = "terminal: toggleable vertical term per dir" })

-- Floating terminal (60% width, 40% height)
map({ "n", "t" }, "<A-i>", function()
  open_term_per_directory {
    pos = "float",
    float_opts = {
      row = 0.15,
      col = 0.2,
      width = 0.6,
      height = 0.5,
    }
  }
end, { desc = "terminal: toggleable float term per dir" })


-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

local dap = require("dap")

-- Basic debugging keymaps!
map('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
map('n', '<F2>', dap.step_over, { desc = 'Debug: Next' })
map('n', '<F1>', dap.step_into, { desc = 'Debug: Into' })
map('n', '<F3>', dap.step_out, { desc = 'Debug: Out' })
map('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: toggle breakpoint' })
map('n', '<leader>B', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: set breakpoint with condition' })

local onedark = require("configs.onedark")

map("n", "<leader>tg", onedark.toggle_transparency, { desc = "Toggle Onedark transparency", noremap = true, silent = true })

map("n", "<leader>dc", ":CodeiumDisable<CR>", { desc = "Disable Codeium" })
map("n", "<leader>ec", ":CodeiumEnable<CR>", { desc = "Enable Codeium" })

-- Open corresponding .pdf/.html or preview
map("n", "<leader>0", ":!opout <C-r>%<CR><CR>", { desc = "Open Output Preview" })

-- Compile, make, create, do shit!
map("n", "<leader>m", ":w! | !compiler '<C-r>%'<CR><CR>", { desc = "Compile Current File" })


