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

local Utils = require("mods.utils")

local toggle_inlay_hint = function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP keymaps",
    callback = function(event)
        local wk = require("which-key")
        local function trouble_lsp(mode)
            return function()
                require("trouble").toggle({
                    mode = mode,
                    focus = true,
                })
            end
        end

        wk.add({ "<leader>g", group = "LSP" })
        wk.add({ "<leader>v", group = "LspActions" })
        local opts = { buffer = event.buf }
        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", trouble_lsp("lsp_definitions"), opts)
        vim.keymap.set("n", "gD", trouble_lsp("lsp_declarations"), opts)
        vim.keymap.set("n", "gi", trouble_lsp("lsp_implementations"), opts)
        vim.keymap.set("n", "go", trouble_lsp("lsp_type_definitions"), opts)
        vim.keymap.set("n", "gO", trouble_lsp("lsp_type_definitions"), opts)
        vim.keymap.set("n", "gr", trouble_lsp("lsp_references"), opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
        vim.keymap.set("n", "gci", trouble_lsp("lsp_incoming_calls"), opts)
        vim.keymap.set("n", "gco", trouble_lsp("lsp_outgoing_calls"), opts)
        vim.keymap.set("n", "<leader>vrn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set("n", "<leader>rn", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end, Utils.extend_opts(opts, { expr = true }))
        vim.keymap.set("n", "<leader>vca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
        vim.keymap.set("n", "gq", "<cmd> lua vim.diagnostic.setloclist()<cr>", opts)
        vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.document_symbol()<cr>", opts)
        vim.keymap.set("i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "gti", toggle_inlay_hint, Utils.extend_opts(opts, { desc = "Toggle inlay hints" }))
    end,
})
