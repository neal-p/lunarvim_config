-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

 
-- NEEDED FOR WSL CLIPBOARD AFTER xclip is installed
-- IF NOT IN WSL leave commented
vim.api.nvim_exec(
[[
let g:clipboard = {
            \   'name': 'WslClipboard',
            \   'copy': {
            \      '+': 'clip.exe',
            \      '*': 'clip.exe',
            \    },
            \   'paste': {
            \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \   },
           \   'cache_enabled': 0,
            \ }
]],
true)

-- Required for compile on HPC
-- which has default ancient c compiler
-- require 'nvim-treesitter.install'.compilers = { "gcc" }

 
-- line numbers plus relative
vim.opt.nu = true
vim.opt.relativenumber = true

-- tabs/indent
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- search options
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

--undo
vim.opt.undodir = vim.fn.expand("$HOME/.local/state/lvim")

-- save session
-- https://github.com/neovim/neovim/issues/16339
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler,
-- for a commit or rebase message
-- (likely a different one than last time), and when using xxd(1) to filter
-- and edit binary files (it transforms input files back and forth, causing
-- them to have dual nature, so to speak)
function RestoreCursorPosition()
  local line = vim.fn.line("'\"")
  if line > 1 and line <= vim.fn.line("$") and vim.bo.filetype ~= 'commit' and vim.fn.index({'xxd', 'gitrebase'}, vim.bo.filetype) == -1 then
    vim.cmd('normal! g`"')
  end
end

if vim.fn.has("autocmd") then
  vim.cmd([[
    autocmd BufReadPost * lua RestoreCursorPosition()
  ]])
end

-- close nvimtree on open
lvim.builtin.nvimtree.setup.actions.open_file.quit_on_open = true


-- system clipboard - normal + visual vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>v', '"+P')
vim.keymap.set('v', '<leader>v', '"+P')


-- Additional plugins
lvim.plugins = {
  { "folke/trouble.nvim" },
  { "CRAG666/code_runner.nvim" },
  { "mfussenegger/nvim-dap" },
  { "mfussenegger/nvim-dap-python" },
  { "ChristianChiarulli/swenv.nvim" },
  { "stevearc/dressing.nvim" },
  { "rose-pine/neovim" },
  { "nordtheme/vim" },
  { "catppuccin/nvim"},
  { "kkoomen/vim-doge", 
        event = "BufRead", 
        config = function()
            if vim.fn.exists(":DogeGenerate") == 0 then
                vim.cmd(":call doge#install()")
            end
        end
    },
}

lvim.colorscheme = "catppuccin"
lvim.tarnsparent_window = true


-- close explorer on file select


-- Docstring generation settings
vim.api.nvim_exec(
[[
let g:doge_doc_standard_python = "google"
]],
true)

vim.api.nvim_exec(
[[
let g:doge_python_settings = {
    \ 'single_quotes' : 0,
    \ 'omit_redundant_param_types' : 0,
\}
]],
true)



-- python environment help
lvim.builtin.which_key.mappings["C"] = {
  name = "Python",
  c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
}

-- Set formaters and linters
lvim.builtin.treesitter.ensure_installed = {
  "python",
  "cpp",
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup({
  { name = "black" },
  {
    name = "clang_format",
    args = { "--style=chromium" },
  },
}
)

 
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.py", "*.cpp", }
--local linters = require "lvim.lsp.null-ls.linters"
--linters.setup({ { command = "flake8", filetypes = { "python"} } }

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  { name = "flake8",  filetypes = { "python" } },
  { name = "cpplint", filetypes = { "cpp" } },
})

 
local clangd_flags = {
  "--all-scopes-completion",
  "--suggest-missing-includes",
  "--background-index",
  "--pch-storage=disk",
  "--cross-file-rename",
  "--log=info",
  "--completion-style=detailed",
  "--enable-config",          -- clangd 11+ supports reading from .clangd configuration file
  "--clang-tidy",
  "--offset-encoding=utf-16", --temporary fix for null-ls
  "--clang-tidy-checks=-*,llvm-*,clang-analyzer-*,modernize-*,-modernize-use-trailing-return-type",
  "--fallback-style=Google",
  "--header-insertion=never",
  "--query-driver=<list-of-white-listed-complers>",
}


local clangd_bin = "clangd"

local opts = {
  cmd = { clangd_bin, unpack(clangd_flags) },
}

require("lvim.lsp.manager").setup("clangd", opts)
vim.diagnostic.config({ virtual_text = false })

 
-- trouble keymaps
lvim.builtin.which_key.mappings["t"] = {
        name = "+Trouble",
        t = { "<cmd>TroubleToggle<cr>", "Trouble Toggle" },
        r = { "<cmd>Trouble lsp_references<cr>", "References" },
        f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
        d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnosticss" },
        q = { "<cmd>Trouble quickfix<cr>", "Quickfix" },
        l = { "<cmd>Trouble loclist<cr>", "LocationList" },
        w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnosticss" },
}
