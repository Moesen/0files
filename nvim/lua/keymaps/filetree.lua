local utils = require('mods.utils')

local function open_neotree(opts)
    local target_dir = opts and opts.dir or vim.fn.getcwd()
    require("neo-tree.command").execute(vim.tbl_extend("force", {
        source = "filesystem",
        position = "left",
        action = "focus",
    }, utils.path.current_buffer_reveal_opts(target_dir), opts or {}))
end

vim.keymap.set("n", "<C-n>", function()
    require("neo-tree.command").execute({
        source = "filesystem",
        position = "left",
        toggle = true,
    })
end, { desc = "Toggle file tree" })

vim.keymap.set("n", "<leader>pv", function()
    open_neotree()
end, { desc = "Focus file tree" })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/0files/nvim/<CR>", { desc = "Open init.lua" })
vim.keymap.set("n", "<leader>pwd", utils.path.copy_current_file_path, { desc = "Copy current file path" })
