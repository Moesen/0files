return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("render-markdown").setup({
                render_modes = { "n", "c", "t" },
                anti_conceal = {
                    enabled = false,
                },
                heading = {
                    sign = true,
                    width = "block",
                    left_pad = 0,
                    right_pad = 1,
                },
                checkbox = {
                    enabled = true,
                    unchecked = { icon = "󰄱 " },
                    checked = { icon = "󰱒 " },
                },
                bullet = {
                    enabled = true,
                },
                code = {
                    sign = true,
                    width = "block",
                },
                pipe_table = {
                    enabled = true,
                    preset = "round",
                },
            })
        end,
    },

    {
        "bullets-vim/bullets.vim",
        ft = { "markdown", "text", "gitcommit" },
        config = function()
            vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
            vim.g.bullets_outline_levels = { "num", "std-", "std*", "std+" }
            vim.g.bullets_renumber_on_change = 1
            vim.g.bullets_set_mappings = 1
        end,
    },
}
