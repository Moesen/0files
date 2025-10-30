local Utils = require("mods.utils")

return {
	"tpope/vim-fugitive",
	config = function()
		local wk = require("which-key")
		wk.add({ "<leader>G", group = "Fugitive" })
		vim.keymap.set("n", "<leader>Go", vim.cmd.Git, { desc = "Open fugitive" })
		vim.api.nvim_create_autocmd("BufWinEnter", {
			group = vim.api.nvim_create_augroup("Moesen_Fugitive", { clear = true }),
			pattern = "*",
			callback = function()
				if vim.bo.ft ~= "fugitive" then
					return
				end
				local bufnr = vim.api.nvim_get_current_buf()
				local opts = { buffer = bufnr, remap = false }
				vim.keymap.set("n", "<leader>Gp", function()
					vim.cmd.Git("push")
				end, Utils.extend_opts(opts, { desc = "Git push" }))
				vim.keymap.set("n", "<leader>Gfp", function()
					vim.cmd.Git({ "push --force-with-lease" })
				end, { desc = "Git push --force-with-lease" })

				-- Always rebase
				vim.keymap.set("n", "<leader>GP", function()
					vim.cmd.Git({ "pull --rebase" })
				end, Utils.extend_opts(opts, { desc = "Git pull --rebase" }))

				-- Note: This is for setting current branch
				vim.keymap.set(
					"n",
					"<leader>Gt",
					":Git push -u origin ",
					Utils.extend_opts(opts, { desc = "Git push -u origin" })
				)
			end,
		})
	end,
}
