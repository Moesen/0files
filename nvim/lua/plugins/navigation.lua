return {
    {
        "swaits/zellij-nav.nvim",
        lazy = true,
        event = "VeryLazy",
        keys = {
            { "<c-h>", "<cmd>ZellijNavigateLeft<cr>",  { silent = true, desc = "navigate left" } },
            { "<c-j>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "navigate down" } },
            { "<c-k>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "navigate up" } },
            { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
        },
        opts = {},
    },

    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
        init = function()
            vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winsize,winpos"

            vim.api.nvim_create_autocmd("VimEnter", {
                nested = true,
                callback = function()
                    if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
                        require("persistence").load()
                    end
                end
            })

            vim.api.nvim_create_autocmd("StdinReadPre", {
                callback = function()
                    vim.g.started_with_stdin = true
                end,
            })
        end,
        keys = {
            {
                "<leader>qs",
                function() require("persistence").load() end,
                desc = "Restore session for current dir",
            },
            {
                "<leader>ql",
                function() require("persistence").load({ last = true }) end,
                desc = "Restore last session",
            },
            {
                "<leader>qd",
                function() require("persistence").stop() end,
                desc = "Don't save current session",
            },
        },
    }
}
