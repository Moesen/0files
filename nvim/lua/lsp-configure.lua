if vim.fn.exists(":LspInfo") == 0 then
    vim.api.nvim_create_user_command("LspInfo", function()
        vim.cmd("checkhealth vim.lsp")
    end, {
        desc = "Alias to :checkhealth vim.lsp for Neovim 0.12+",
    })
end

if vim.fn.exists(":LspRestart") == 0 then
    vim.api.nvim_create_user_command("LspRestart", function()
        local clients = vim.lsp.get_clients()
        if vim.tbl_isempty(clients) then
            vim.notify("LspRestart: no active LSP clients", vim.log.levels.INFO)
            return
        end

        local buffers_by_client = {}
        for _, client in ipairs(clients) do
            buffers_by_client[client.name] = vim.lsp.get_buffers_by_client_id(client.id)
            client:stop(true)
        end

        vim.defer_fn(function()
            for name, bufs in pairs(buffers_by_client) do
                for _, bufnr in ipairs(bufs) do
                    if vim.api.nvim_buf_is_valid(bufnr) then
                        vim.api.nvim_buf_call(bufnr, function()
                            vim.cmd("edit")
                        end)
                    end
                end
                vim.notify("LspRestart: restarted " .. name, vim.log.levels.INFO)
            end
        end, 200)
    end, {
        desc = "Stop all active LSP clients and re-attach them to their buffers",
    })
end

vim.diagnostic.config({
    virtual_text = {
        source = true,
    },
    float = {
        source = true,
    },
})

local vue_language_server_path = vim.fn.stdpath("data")
    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

vim.lsp.config("ts_ls", {
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
    },
    init_options = {
        hostInfo = "neovim",
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
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


vim.lsp.config("tailwindcss", {
    filetypes = { "svelte", "css", "html" },
})

vim.lsp.config("yamlls", {
    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
                    "docker-compose.yaml",
                    "docker-compose.yml",
                    "compose.yaml",
                    "compose.yml",
                },
            },
        },
    },
})
