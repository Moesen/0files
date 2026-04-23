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
        "norcalli/nvim-colorizer.lua",
        cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
        init = function()
            require("colorizer").setup({})
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    { "nvim-mini/mini.icons",        version = "*" },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        "swaits/zellij-nav.nvim",
        lazy = true,
        event = "VeryLazy",
        keys = {
            { "<c-h>", "<cmd>ZellijNavigateLeft<cr>",  { silent = true, desc = "navigate left" } },
            { "<c-j>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "navigate down" } },
            { "<c-k>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "navigate up" } },
            { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
        },
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
        end, -- for default options, refer to the configuration section for custom setup.
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
    {
        "kylechui/nvim-surround",
        version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                surrounds = {
                    ["g"] = {
                        add = function()
                            local config = require("nvim-surround.config")
                            local result = config.get_input("Enter function/generic name: ")
                            if result then
                                return { { result .. "<" }, { ">" } }
                            end
                        end,
                        find = function()
                            return require("nvim-surround.config").get_selection({ motion = "ag" })
                        end,
                    },
                    ["G"] = {
                        add = function()
                            local config = require("nvim-surround.config")
                            local result = config.get_input("Enter function/generic name: ")
                            if result then
                                return { { result .. "[" }, { "]" } }
                            end
                        end,
                        find = function()
                            return require("nvim-surround.config").get_selection({ motion = "ag" })
                        end,
                    },
                },
            })
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        "mbbill/undotree",
        init = function()
            vim.g.undotree_WindowLayout = 3
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_SplitWidth = 36
        end,
        keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "UndotreeToggle" } },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        "nvim-mini/mini.align",
        version = false,
        config = function()
            require("mini.align").setup({})
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        config = function()
            require("noice").setup({
                cmdline = {
                    view = "cmdline",
                },
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                    },
                    message = {
                        view = "mini",
                    },
                },
                routes = {
                    {
                        filter = {
                            kind = "warn",
                        },
                        view = "mini",
                    },
                },
                notify = {
                    view = "mini",
                },
                messages = {
                    view = "mini",
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = true,       -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = true,            -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true,        -- add a border to hover docs and signature help
                },
            })
        end,
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
    },
    {
        "smjonas/inc-rename.nvim",
        opts = {},
    },
    { "lewis6991/gitsigns.nvim" },
}
