-- return {
-- 	"webhooked/kanso.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	name = "kanso",
-- 	config = function()
-- 		require("kanso").setup({
-- 			background = {
-- 				dark = "mist",
-- 				light = "pearl",
-- 			},
-- 			vim.cmd([[colorscheme kanso]]),
-- 		})
-- 	end,
-- }
-- return {
-- 	"zenbones-theme/zenbones.nvim",
-- 	-- Optionally install Lush. Allows for more configuration or extending the colorscheme
-- 	-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
-- 	-- In Vim, compat mode is turned on as Lush only works in Neovim.
-- 	dependencies = { "rktjmp/lush.nvim" },
-- 	lazy = false,
-- 	priority = 1000,
-- 	-- you can set set configuration options here
-- 	config = function()
-- 		vim.g.zenbones_darken_comments = 50
-- 		vim.g.zenbones_solid_line_nr = true
-- 		-- vim.g.zenbones_darkness = "warm"
-- 		vim.cmd.colorscheme("zenbones")
-- 	end,
-- }
-- return {
-- 	"bluz71/vim-moonfly-colors",
-- 	name = "moonfly",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd.colorscheme("moonfly")
-- 	end,
-- }
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "auto",
            background = {
                light = "frappe",
                dark = "mocha"
            },
            custom_highlights = function(colors)
                return {
                    TreesitterContext = { bg = colors.mantle },
                    TreesitterContextLineNumber = { bg = colors.mantle, fg = colors.overlay1 },
                    TreesitterContextSeparator = { fg = colors.surface2, bg = colors.base },
                    TreesitterContextBottom = { underline = true, sp = colors.surface2 },
                    TreesitterContextLineNumberBottom = { underline = true, sp = colors.surface2 },
                }
            end,
        })
        vim.cmd.colorscheme("catppuccin")
    end
}
