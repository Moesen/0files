vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				diagnosticMode = "openFilesOnly",
				typeCheckingMode = "basic",
			},
		},
	},
})

vim.lsp.config("bashls", {
	filetypes = { "bash", "sh", "zsh" },
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.tf", "*.tfvars" },
	command = "set filetype=terraform",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.hcl", ".terraformrc", "terraform.rc" },
	command = "set filetype=hcl",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.tfstate", "*.tfstate.backup" },
	command = "set filetype=hcl",
})

vim.lsp.config("terraformls", {
	filetypes = { "terraform", "terraform-vars" },
})

vim.lsp.config("tflint", {
	filetypes = { "terraform" },
})
