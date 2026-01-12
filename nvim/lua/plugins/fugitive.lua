local Utils = require("mods.utils")

return {
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
}
