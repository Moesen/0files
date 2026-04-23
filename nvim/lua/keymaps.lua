local Color = require("mods.color")
local wk = require("which-key")

local function current_buffer_file_path()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == "" or bufname:match("^%a+://") then
        return nil
    end

    local absolute_path = vim.fn.fnamemodify(bufname, ":p")
    local stat = vim.uv.fs_stat(absolute_path)
    if stat and stat.type == "file" then
        return absolute_path
    end

    return nil
end

local function path_is_within_root(path, root)
    local normalized_path = vim.fs.normalize(path)
    local normalized_root = vim.fs.normalize(vim.fn.fnamemodify(root, ":p"))
    return normalized_path == normalized_root
        or normalized_path:sub(1, #normalized_root + 1) == normalized_root .. "/"
end

local function current_buffer_reveal_opts(root)
    local filepath = current_buffer_file_path()
    if not filepath then
        return {}
    end

    local reveal_root = root or vim.fn.getcwd()
    if path_is_within_root(filepath, reveal_root) then
        return { reveal_file = filepath }
    end

    return {}
end

local function open_neotree(opts)
    local target_dir = opts and opts.dir or vim.fn.getcwd()
    require("neo-tree.command").execute(vim.tbl_extend("force", {
        source = "filesystem",
        position = "left",
        action = "focus",
    }, current_buffer_reveal_opts(target_dir), opts or {}))
end

local function current_file_repo_root(filepath)
    local dir = vim.fn.fnamemodify(filepath, ":h")
    local git_root = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })[1]
    if vim.v.shell_error == 0 and git_root and git_root ~= "" then
        return git_root
    end
    return nil
end

local function format_python_module(filepath, repo_root)
    local base_path = repo_root and vim.fs.relpath(repo_root, filepath) or filepath
    if not base_path or base_path == "" then
        return filepath
    end

    local module_path = base_path:gsub("%.py$", ""):gsub("/", ".")
    module_path = module_path:gsub("^%.+", "")
    module_path = module_path:gsub("%.__init__$", "")

    if module_path == "" then
        return repo_root or filepath
    end

    return module_path
end

local function copy_current_file_path()
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath == "" then
        vim.notify("Current buffer has no file path", vim.log.levels.WARN)
        return
    end

    local absolute_path = vim.fn.fnamemodify(filepath, ":p")
    local repo_root = current_file_repo_root(absolute_path)
    local copied_path

    if absolute_path:match("%.py$") then
        copied_path = format_python_module(absolute_path, repo_root)
    elseif repo_root then
        copied_path = "/" .. vim.fs.relpath(repo_root, absolute_path)
    else
        copied_path = absolute_path
    end

    vim.fn.setreg("+", copied_path)
    vim.notify("Copied path: " .. copied_path)
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
vim.keymap.set("n", "<leader>pwd", copy_current_file_path, { desc = "Copy current file path" })
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
    local filepath = current_buffer_file_path()
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

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Nicer down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Nicer up" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank selection to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank whole line" })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "Nvim source current file" })

vim.keymap.set("n", "<Tab>", ">>", { desc = "Tab right" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Tab left" })
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Tab right" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Tab left" })
vim.keymap.set("n", "<C-p>", "<C-i>") -- Have to do as <C-i> same as <S-Tab>
vim.keymap.set("n", "<C-t>", "<cmd>tabnew<cr>", { desc = "New tab" })
vim.keymap.set("n", "<C-Tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<C-S-Tab>", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

vim.keymap.set("n", "<leader>n", "<cmd>noh<cr>", { desc = "Stop highlighting seach match" })

-- Terraform commands
wk.add({ "<leader>t", group = "Terraform" })
vim.keymap.set("n", "<leader>ti", "<cmd>!terraform init<CR>", { desc = "Terraform init" })
vim.keymap.set("n", "<leader>tv", "<cmd>!terraform validate<CR>", { desc = "Terraform validate" })
vim.keymap.set("n", "<leader>tp", "<cmd>!terraform plan<CR>", { desc = "Terraform plan" })
vim.keymap.set("n", "<leader>ta", "<cmd>!terraform apply<CR>", { desc = "Terraform apply" })

wk.add({ "<leader>m", group = "Mods" })
wk.add({ "<leader>p", group = "Telescope" })
vim.keymap.set("n", "<leader>mbg", Color.change_bg, { desc = "Change background" })
wk.add({ "<leader>x", group = "Trouble" })

wk.add({ "<leader>o", group = "Octo" })

-- in your config (e.g. lua/utils/yank_matches.lua or directly in init.lua)
local function yank_matches(pattern)
    if not pattern or pattern == "" then
        vim.ui.input({ prompt = "Pattern: " }, function(input)
            if input then
                yank_matches(input)
            end
        end)
        return
    end

    local results = {}
    for lnum = 1, vim.api.nvim_buf_line_count(0) do
        local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
        for match in line:gmatch(pattern) do
            table.insert(results, { lnum = lnum, text = match, line = line })
        end
    end

    if #results == 0 then
        vim.notify("No matches found", vim.log.levels.WARN)
        return
    end

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers
        .new({}, {
            prompt_title = "Matches for: " .. pattern,
            finder = finders.new_table({
                results = results,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry.lnum .. ": " .. entry.text,
                        ordinal = entry.text,
                        filename = vim.api.nvim_buf_get_name(0),
                        lnum = entry.lnum,
                    }
                end,
            }),
            sorter = conf.generic_sorter({}),
            previewer = conf.grep_previewer({}),
            attach_mappings = function(prompt_bufnr, map)
                -- <CR> copies selected match
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    vim.fn.setreg("+", selection.value.text)
                    vim.notify("Copied: " .. selection.value.text)
                end)
                -- <C-y> copies ALL matches
                map("i", "<C-y>", function()
                    local all = table.concat(
                        vim.tbl_map(function(r)
                            return r.text
                        end, results),
                        "\n"
                    )
                    actions.close(prompt_bufnr)
                    vim.fn.setreg("+", all)
                    vim.notify(("Copied all %d matches"):format(#results))
                end)
                return true
            end,
        })
        :find()
end

vim.api.nvim_create_user_command("YankMatches", function(opts)
    yank_matches(opts.args ~= "" and opts.args or nil)
end, { nargs = "?" })
