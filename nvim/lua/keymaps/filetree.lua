local utils = require('mods.utils')
local BranchTree = require('mods.branch_tree')

local function open_neotree(opts)
    local target_dir = opts and opts.dir or vim.fn.getcwd()
    require("neo-tree.command").execute(vim.tbl_extend("force", {
        source = "filesystem",
        position = "left",
        action = "focus",
    }, utils.path.current_buffer_reveal_opts(target_dir), opts or {}))
end

vim.keymap.set("n", "<C-n>", function()
    require("neo-tree.command").execute(vim.tbl_extend("force", {
        position = "left",
        toggle = true,
    }, (BranchTree.source_opts())))
end, { desc = "Toggle file tree" })

vim.keymap.set("n", "<leader>pv", function()
    if BranchTree.is_enabled() then
        require("neo-tree.command").execute(vim.tbl_extend("force", {
            position = "left",
            action = "focus",
        }, (BranchTree.source_opts())))
        return
    end
    open_neotree()
end, { desc = "Focus file tree" })

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


vim.keymap.set("n", "<leader>mpb", BranchTree.toggle, { desc = "Toggle file tree: changes vs parent branch" })
