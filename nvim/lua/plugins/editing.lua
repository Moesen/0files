return {
    {
        "kylechui/nvim-surround",
        version = "^3.0.0",
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
        "mbbill/undotree",
        init = function()
            vim.g.undotree_WindowLayout = 3
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_SplitWidth = 36
        end,
        keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "UndotreeToggle" } },
    },
    {
        "smjonas/inc-rename.nvim",
        opts = {},
    },
}
