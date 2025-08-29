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
}
