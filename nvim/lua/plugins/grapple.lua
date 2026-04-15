return {
	{
		"cbochs/grapple.nvim",
		event = { "BufReadPost", "BufNewFile" },
		cmd = "Grapple",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		init = function()
			require("which-key").add({ "<leader>h", group = "Bookmarks" })
		end,
		opts = {
			scope = "git",
		},
		keys = {
			{
				"<leader>hm",
				function()
					require("grapple").toggle()
				end,
				desc = "Toggle bookmark",
			},
			{
				"<leader>hh",
				function()
					require("telescope").extensions.grapple.tags()
				end,
				desc = "Show bookmarks",
			},
			{
				"<leader>hr",
				function()
					require("grapple").untag()
				end,
				desc = "Remove bookmark",
			},
		},
	},
}
