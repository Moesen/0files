return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			version = "^1.1.0",
		},
	},
	keys = {
		{ "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{
			"<leader>pg",
			function()
				require("telescope").extensions.live_grep_args.live_grep_args()
			end,
			desc = "Live Grep",
		},
		{ "<leader>pd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		{ "<leader>pc", "<cmd>Telescope spell_suggest<cr>", desc = "Spell Suggest" },
		{
			"<leader>pg",
			function()
				vim.cmd('noau normal! "vy"')
				local text = vim.fn.getreg("v")
				text = text:gsub("\n", " "):gsub("^%s+", ""):gsub("%s+$", "")
				require("telescope").extensions.live_grep_args.live_grep_args({
					default_text = text,
				})
			end,
			mode = "v",
			desc = "Grep selected text",
		},
	},
	opts = function()
		local lga_actions = require("telescope-live-grep-args.actions")

		return {
			defaults = {
				layout_strategy = "horizontal",
				sorting_strategy = "ascending",
				prompt_prefix = "   ",
				selection_caret = "  ",
				path_display = { "truncate" },
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.65,
						results_width = 0.35,
					},
					width = 0.95,
					height = 0.92,
					preview_cutoff = 80,
				},
				preview = {
					treesitter = false,
				},
				mappings = {
					i = {
						["<C-k>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					},
				},
			},
			pickers = {
				find_files = {},
				live_grep = {
					previewer = true,
					additional_args = function()
						return { "--trim" }
					end,
				},
				spell_suggest = {
					theme = "cursor",
				},
				diagnostics = {
					cwd_only = true,
				},
			},
			extensions = {
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							["<C-k>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
						},
					},
				},
			},
		}
	end,
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("live_grep_args")
	end,
}
