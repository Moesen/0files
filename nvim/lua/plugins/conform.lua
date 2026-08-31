vim.api.nvim_create_user_command("ConformFormatOnSaveDisable", function(args)
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})
vim.api.nvim_create_user_command("ConformFormatOnSaveEnable", function(args)
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Enable autoformat-on-save",
})

return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            -- Customize or remove this keymap to your liking
            "<leader>f",
            function()
                require("conform").format({ formatters = { "ruff_organize_imports" } })
            end,
            desc = "Organize Python imports",
        },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        -- Define your formatters

        formatters_by_ft = {
            lua = { "stylua" },
            -- python = { "ruff_fix", "ruff_format" },
            python = { "ruff_format" },
            -- javascript = { "prettierd" },
            -- typescript = { "prettierd" },
            javascript = { "biome-check" },
            typescript = { "biome-check" },
            html = { "djlint" },
            json = { "jq" },
            jsonc = { "jq" },
            css = { "prettierd" },
            c = { "clang-format" },
            jsonl = { "jq" },
            rust = { "rustfmt", lsp_format = "fallback" },
            svelte = { "prettierd" },
            terraform = { "terraform_fmt" },
            ["_"] = { "trim_whitespace" },
        },

        -- Set default options
        default_format_opts = {
            lsp_format = "fallback",
        },
        -- Set up format-on-save
        format_on_save = function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            return { timeout_ms = 500, lsp_format = "fallback" }
        end,
        -- Customize formatters
        formatters = {
            ruff_organize_imports = {
                command = "uv",
                args = {
                    "tool",
                    "run",
                    "ruff",
                    "check",
                    "--fix",
                    "--force-exclude",
                    "--select=I001",
                    "--exit-zero",
                    "--no-cache",
                    "--stdin-filename",
                    "$FILENAME",
                    "-",
                },
                stdin = true,
            },
            shfmt = {
                prepend_args = { "-i", "2" },
            },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
