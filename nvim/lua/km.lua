local Color = require("mods.color")
local wk = require("which-key")

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
