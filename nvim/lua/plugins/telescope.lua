return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	keys = {
		{ "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>pg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
		{ "<leader>pd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		{ "<leader>pc", "<cmd>Telescope spell_suggest<cr>", desc = "Spell Suggest" },
	},
	opts = {
		pickers = {
			find_files = {},
			spell_suggest = {
				theme = "cursor",
			},
			diagnostics = {
				cwd_only = true,
			},
		},
	},
}
