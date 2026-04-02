vim.g.mapleader = " "
vim.g.maplocalleader = ";"
vim.g.python3_host_prog = "~/0files/cli-tools/uv/.venv/bin/python"
vim.o.termguicolors = true

local function normalize_path()
    local seen = {}
    local parts = {}

    for _, entry in ipairs(vim.split(vim.env.PATH or "", ":", { plain = true, trimempty = true })) do
        if not entry:match("^%d+$") and not seen[entry] then
            seen[entry] = true
            table.insert(parts, entry)
        end
    end

    for _, entry in ipairs({ "/opt/homebrew/bin", "/opt/homebrew/sbin", "/usr/local/bin", "/usr/local/sbin" }) do
        if vim.uv.fs_stat(entry) and not seen[entry] then
            table.insert(parts, 1, entry)
            seen[entry] = true
        end
    end

    vim.env.PATH = table.concat(parts, ":")
end

normalize_path()

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    change_detection = { notify = false },
    checker = { enabled = true },
})

-- Load vim configs
require("options")
require("keymaps")
require("autocommands")
require("lsp-configure")

require("lualine").setup({})

local Colors = require("mods.color")
Colors.set_bg()
