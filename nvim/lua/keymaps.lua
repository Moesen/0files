local Color = require("mods.color")
local wk = require("which-key")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw" })
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/0files/nvim/<CR>", { desc = "Open init.lua" })
-- Open netrw in repo root if it exists
vim.keymap.set("n", "<leader>pr", function()
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error == 0 then
		vim.cmd("cd " .. git_root)
		vim.cmd("Ex")
	else
		print("Not in a git repository")
	end
end, { desc = "Open netrw at repo root" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Nicer down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Nicer up" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank selection to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank whole line" })

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end, { desc = "Nvim source current file" })

vim.keymap.set("n", "<Tab>", ">>", { desc = "Tab right" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Tab left" })
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Tab right" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Tab left" })
vim.keymap.set("n", "<C-p>", "<C-i>") -- Have to do as <C-i> same as <S-Tab>

vim.keymap.set("n", "<leader>n", "<cmd>noh<cr>", { desc = "Stop highlighting seach match" })

-- Terraform commands
wk.add({ "<leader>t", group = "Terraform" })
vim.keymap.set("n", "<leader>ti", "<cmd>!terraform init<CR>", { desc = "Terraform init" })
vim.keymap.set("n", "<leader>tv", "<cmd>!terraform validate<CR>", { desc = "Terraform validate" })
vim.keymap.set("n", "<leader>tp", "<cmd>!terraform plan<CR>", { desc = "Terraform plan" })
vim.keymap.set("n", "<leader>ta", "<cmd>!terraform apply<CR>", { desc = "Terraform apply" })

wk.add({ "<leader>m", group = "Mods" })
wk.add({ "<leader>p", group = "Telescope" })
vim.keymap.set("n", "<leader>mbg", Color.change_bg, { desc = "Change background" })
wk.add({ "<leader>x", group = "Trouble" })
