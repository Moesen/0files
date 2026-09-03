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
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
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
