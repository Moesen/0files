return {
    { "Issafalcon/lsp-overloads.nvim" },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile", "BufEnter" },
        cmd = { "PythonLspPicker" },
        keys = {
            {
                "<leader>mlsp",
                function()
                    require("mods.python_lsp").pick()
                end,
                desc = "Python LSPs",
            },
        },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "mason-org/mason.nvim" },
            { "mason-org/mason-lspconfig.nvim" },
        },
        config = function()
            require("lsp-configure")

            -- Setup defaults
            local lsp_defaults = require("lspconfig").util.default_config
            local python_lsp = require("mods.python_lsp")

            lsp_defaults.capabilities =
                vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

            require("mason").setup({})
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "dockerls",
                    -- "basedpyright",
                    -- "pyrefly",
                    "ty",
                    "ruff",
                    "ts_ls",
                    -- "html",
                    "bashls",
                    "svelte",
                },
                automatic_enable = {
                    exclude = python_lsp.servers,
                },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({})
                    end,
                },
            })
            python_lsp.setup()
        end,
    },
}
