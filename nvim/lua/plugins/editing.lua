return {
    {
        "kylechui/nvim-surround",
        version = "^3.0.0",
        event = "VeryLazy",
        config = function()
            local typescript_generic_syntax = {
                opening = "<",
                closing = ">",
                find = "[%w_.$:@'%-]+%b<>",
                delete = "^(.-<)().-(>)()$",
            }

            local generic_syntax = {
                python = {
                    opening = "[",
                    closing = "]",
                    find = "[%w_.$:@'%-]+%b[]",
                    delete = "^(.-%[)().-(%])()$",
                },
                typescript = typescript_generic_syntax,
                typescriptreact = typescript_generic_syntax,
                vue = typescript_generic_syntax,
                svelte = typescript_generic_syntax,
            }

            local function get_generic_syntax()
                return generic_syntax[vim.bo.filetype]
            end

            require("nvim-surround").setup({
                surrounds = {
                    ["g"] = {
                        add = function()
                            local syntax = get_generic_syntax()
                            if not syntax then
                                return
                            end

                            local config = require("nvim-surround.config")
                            local result = config.get_input("Enter function/generic name: ")
                            if result then
                                return { { result .. syntax.opening }, { syntax.closing } }
                            end
                        end,
                        find = function()
                            local syntax = get_generic_syntax()
                            if syntax then
                                return require("nvim-surround.config").get_selection({
                                    pattern = syntax.find,
                                })
                            end
                        end,
                        delete = function()
                            local syntax = get_generic_syntax()
                            if syntax then
                                return require("nvim-surround.config").get_selections({
                                    char = "g",
                                    pattern = syntax.delete,
                                })
                            end
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
