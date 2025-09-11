vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- Open netrw
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/0files/nvim/init.lua<CR>")

vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Nicer down
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Nicer down

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- Yank selection to clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]]) -- Yank whole line

vim.keymap.set("n", "<leader><leader>", function() -- Nvim source current file
	vim.cmd("so")
end)

vim.keymap.set("n", "<Tab>", ">>") -- Tab right
vim.keymap.set("n", "<S-Tab>", "<<") -- Tab left
vim.keymap.set("v", "<Tab>", ">gv") -- Tab right
vim.keymap.set("v", "<S-Tab>", "<gv") -- Tab left
vim.keymap.set("n", "<C-p>", "<C-i>") -- Have to do as <C-i> same as <S-Tab>

vim.keymap.set("n", "<leader>n", "<cmd>noh<cr>") -- Stop highlighting search match

-- Terraform commands
vim.keymap.set("n", "<leader>ti", "<cmd>!terraform init<CR>")
vim.keymap.set("n", "<leader>tv", "<cmd>!terraform validate<CR>")
vim.keymap.set("n", "<leader>tp", "<cmd>!terraform plan<CR>")
vim.keymap.set("n", "<leader>ta", "<cmd>!terraform apply<CR>")

local bg_mode = "dark"
local function set_bg()
	vim.o.bg = bg_mode
end

local function change_bg()
	if bg_mode == "dark" then
		bg_mode = "light"
	else
		bg_mode = "dark"
	end
	set_bg()
end

vim.keymap.set("n", "<leader>lbg", change_bg)
