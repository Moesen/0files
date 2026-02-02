local Utils = require("mods.utils")

return {
	{
		"tpope/vim-fugitive",
		config = function()
			local wk = require("which-key")
			wk.add({ "<leader>g", group = "fugitive" })
			vim.keymap.set("n", "<leader>go", vim.cmd.Git, { desc = "Open fugitive" })
			vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "git blame" })
			vim.api.nvim_create_autocmd("BufWinEnter", {
				group = vim.api.nvim_create_augroup("Moesen_Fugitive", { clear = true }),
				pattern = "*",
				callback = function()
					if vim.bo.ft ~= "fugitive" then
						return
					end
					local bufnr = vim.api.nvim_get_current_buf()
					local opts = { buffer = bufnr, remap = false }
					vim.keymap.set("n", "<leader>gp", function()
						vim.cmd.Git("push")
					end, Utils.extend_opts(opts, { desc = "git push" }))
					vim.keymap.set("n", "<leader>gfp", function()
						vim.cmd.Git({ "push --force-with-lease" })
					end, { desc = "git push --force-with-lease" })

					-- Always rebase
					vim.keymap.set("n", "<leader>gP", function()
						vim.cmd.Git({ "pull --rebase" })
					end, Utils.extend_opts(opts, { desc = "git pull --rebase" }))
					vim.keymap.set("n", "<leader>grm", function()
						vim.cmd.Git({ "rebase -i --autosquash main" })
					end, Utils.extend_opts(opts, { desc = "git rebase -i --autosquash main" }))

					-- Note: This is for setting current branch
					vim.keymap.set(
						"n",
						"<leader>gt",
						":Git push -u origin ",
						Utils.extend_opts(opts, { desc = "git push -u origin" })
					)
				end,
			})
		end,
	},
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		opts = {
			-- or "fzf-lua" or "snacks" or "default"
			picker = "telescope",
			-- bare Octo command opens picker of commands
			enable_builtin = true,
		},
		keys = {
			{
				"<leader>oi",
				"<CMD>Octo issue list<CR>",
				desc = "List GitHub Issues",
			},
			{
				"<leader>op",
				"<CMD>Octo pr list<CR>",
				desc = "List GitHub PullRequests",
			},
			{
				"<leader>od",
				"<CMD>Octo discussion list<CR>",
				desc = "List GitHub Discussions",
			},
			{
				"<leader>on",
				"<CMD>Octo notification list<CR>",
				desc = "List GitHub Notifications",
			},
			{
				"<leader>os",
				function()
					require("octo.utils").create_base_search_command({ include_current_repo = true })
				end,
				desc = "Search GitHub",
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			-- OR "ibhagwan/fzf-lua",
			-- OR "folke/snacks.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	},
}
