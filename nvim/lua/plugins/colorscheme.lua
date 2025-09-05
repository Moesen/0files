return {
	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	name = "kanagawa",
	-- 	config = function()
	-- 		vim.cmd([[colorscheme kanagawa]])
	-- 	end,
	-- },
	{
		"webhooked/kanso.nvim",
		lazy = false,
		priority = 1000,
		name = "kanso",
		config = function()
			vim.cmd([[colorscheme kanso]])
		end,
	},
}
