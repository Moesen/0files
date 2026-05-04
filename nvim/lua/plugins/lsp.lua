return {
    { "Issafalcon/lsp-overloads.nvim" },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile", "BufEnter" },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "mason-org/mason.nvim" },
            { "mason-org/mason-lspconfig.nvim" },
        },
        config = function()
            vim.lsp.config("*", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            require("mason").setup({})
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "dockerls",
                    "ruff",
                    "ts_ls",
                    "html",
                    "bashls",
                },
            })
        end,
    },
}
