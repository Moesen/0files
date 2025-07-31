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
