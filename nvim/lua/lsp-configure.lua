local helm = require("mods.helm")

vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				diagnosticMode = "workspace",
				typeCheckingMode = "basic",
				autoImportCompletions = true,
				indexing = true,
			},
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return
		end
		if client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "LSP: Disable hover capability from Ruff",
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

vim.lsp.config("helm_ls", {
	filetypes = { "helm.yaml", "helm.tmpl", "yaml", "helm" },
	settings = {
		["helm-ls"] = {
			yamlls = {
				path = "yaml-language-server",
			},
		},
	},
})

vim.lsp.config("tailwindcss", {
	filetypes = { "svelte", "css", "html" },
})

vim.lsp.config("yamlls", {})

vim.filetype.add({
	extension = {
		yaml = helm.yaml_filetype,
		yml = helm.yaml_filetype,
		tmpl = helm.tmpl_filetype,
		tpl = helm.tpl_filetype,
	},
	filename = {
		["Chart.yaml"] = "yaml",
		["Chart.lock"] = "yaml",
	},
})
