return {
	{
		"webhooked/kanso.nvim",
		lazy = false,
		priority = 1000,
		name = "kanso",
		config = function()
			require("kanso").setup({
				background = {
					dark = "mist",
					light = "pearl",
				},
			})
			vim.cmd([[colorscheme kanso]])
		end,
	},
}
