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
			require("peek").setup({
				app = "chromium",
			})
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
	{
		"swaits/zellij-nav.nvim",
		lazy = true,
		event = "VeryLazy",
		keys = {
			{ "<c-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left" } },
			{ "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
			{ "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
			{ "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
		},
		opts = {},
	},
	{
		"folke/trouble.nvim",
		opts = {
			win = {
				size = 0.4,
			},
		}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>xs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols",
			},
			{
				"<leader>xl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... ",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List",
			},
		},
	},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				surrounds = {
					["g"] = {
						add = function()
							local config = require("nvim-surround.config")
							local result = config.get_input("Enter function/generic name: ")
							if result then
								return { { result .. "<" }, { ">" } }
							end
						end,
						find = function()
							return require("nvim-surround.config").get_selection({ motion = "ag" })
						end,
					},
					["G"] = {
						add = function()
							local config = require("nvim-surround.config")
							local result = config.get_input("Enter function/generic name: ")
							if result then
								return { { result .. "[" }, { "]" } }
							end
						end,
						find = function()
							return require("nvim-surround.config").get_selection({ motion = "ag" })
						end,
					},
				},
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"mbbill/undotree",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "UndotreeToggle" } },
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
}
