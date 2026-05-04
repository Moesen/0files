return {
    { "nvim-mini/mini.icons",        version = "*" },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        "norcalli/nvim-colorizer.lua",
        cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
        init = function()
            require("colorizer").setup({})
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
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
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        config = function()
            require("noice").setup({
                cmdline = {
                    view = "cmdline",
                },
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
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
                presets = {
                    bottom_search = true,
                    command_palette = true,
                    long_message_to_split = true,
                    inc_rename = true,
                    lsp_doc_border = true,
                },
            })
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
}
