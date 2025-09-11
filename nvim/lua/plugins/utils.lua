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
	{ "nvim-mini/mini.icons", version = "*" },
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup()
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
}
