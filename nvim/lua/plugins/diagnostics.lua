local last_trouble_view = nil

local function close_all_trouble()
    local views = require("trouble.view").get({ open = true })
    for _, entry in ipairs(views) do
        entry.view:close()
    end
end

local function trouble_sidebar(name, opts)
    return function()
        local views = require("trouble.view").get({ open = true })
        local has_open = #views > 0

        if has_open and last_trouble_view == name then
            close_all_trouble()
            last_trouble_view = nil
            return
        end

        if has_open then
            close_all_trouble()
        end

        require("trouble").open(vim.tbl_deep_extend("force", {
            focus = true,
        }, opts))
        last_trouble_view = name
    end
end

return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "folke/trouble.nvim",
        opts = function()
            return {
                focus = false,
                follow = true,
                pinned = false,
                win = {
                    type = "split",
                    relative = "editor",
                    position = "right",
                    size = 0.30,
                },
                preview = {
                    type = "main",
                },
                modes = {
                    diagnostics = {
                        win = { position = "right", size = 0.33 },
                    },
                    symbols = {
                        win = { position = "right", size = 0.26 },
                    },
                    lsp = {
                        win = { position = "right", size = 0.30 },
                    },
                    lsp_incoming_calls = {
                        win = { position = "right", size = 0.30 },
                    },
                    lsp_outgoing_calls = {
                        win = { position = "right", size = 0.30 },
                    },
                    loclist = {
                        win = { position = "right", size = 0.28 },
                    },
                    qflist = {
                        win = { position = "right", size = 0.28 },
                    },
                },
            }
        end,
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                trouble_sidebar("diagnostics", { mode = "diagnostics" }),
                desc = "Diagnostics",
            },
            {
                "<leader>xX",
                trouble_sidebar("buffer_diagnostics", { mode = "diagnostics", filter = { buf = 0 } }),
                desc = "Buffer Diagnostics",
            },
            {
                "<leader>xs",
                trouble_sidebar("symbols", { mode = "symbols" }),
                desc = "Symbols",
            },
            {
                "<leader>xl",
                trouble_sidebar("lsp", { mode = "lsp" }),
                desc = "LSP Definitions / references / ... ",
            },
            {
                "<leader>xi",
                trouble_sidebar("lsp_incoming_calls", { mode = "lsp_incoming_calls" }),
                desc = "Incoming Calls",
            },
            {
                "<leader>xo",
                trouble_sidebar("lsp_outgoing_calls", { mode = "lsp_outgoing_calls" }),
                desc = "Outgoing Calls",
            },
            {
                "<leader>xL",
                trouble_sidebar("loclist", { mode = "loclist" }),
                desc = "Location List",
            },
            {
                "<leader>xQ",
                trouble_sidebar("qflist", { mode = "qflist" }),
                desc = "Quickfix List",
            },
            {
                "<leader>xt",
                function()
                    local views = require("trouble.view").get({ open = true })
                    if #views > 0 then
                        close_all_trouble()
                        return
                    end

                    require("trouble").open({
                        mode = last_trouble_view or "diagnostics",
                        focus = true,
                    })
                end,
                desc = "Toggle Trouble",
            },
        },
    },
}
