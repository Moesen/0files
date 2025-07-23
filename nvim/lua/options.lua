vim.g.mapleader = " "
vim.g.python3_host_prog = "~/0files/nvim/env/.venv/bin/python3"

vim.opt.nu = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch  = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 30

vim.opt.colorcolumn = "85"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
