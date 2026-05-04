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
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    vim.fn.setreg("+", selection.value.text)
                    vim.notify("Copied: " .. selection.value.text)
                end)
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
