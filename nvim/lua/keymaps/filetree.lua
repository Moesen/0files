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

-- Open file tree in repo root if it exists
vim.keymap.set("n", "<leader>pr", function()
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if vim.v.shell_error == 0 then
        vim.cmd("cd " .. vim.fn.fnameescape(git_root))
        open_neotree({ dir = git_root })
    else
        print("Not in a git repository")
    end
end, { desc = "Focus file tree at repo root" })
vim.keymap.set("n", "<leader>pR", function()
    local filepath = utils.path.current_buffer_file_path()
    if not filepath then
        vim.notify("Current buffer has no file path", vim.log.levels.WARN)
        return
    end

    local dir = vim.fn.fnamemodify(filepath, ":h")
    vim.cmd("cd " .. vim.fn.fnameescape(dir))
    open_neotree({
        dir = dir,
        reveal_file = filepath,
        reveal_force_cwd = true,
    })
end, { desc = "Focus file tree at current file dir" })
