return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        init = function()
            local sys = vim.uv.os_uname().sysname
            local is_mac = sys == "Darwin"

            local has_ts = vim.fn.executable("tree-sitter") == 1
            local has_cc = vim.fn.executable("cc") == 1
                or vim.fn.executable("clang") == 1
                or vim.fn.executable("gcc") == 1

            vim.g._ts_is_mac = is_mac
            vim.g._ts_has_cc = has_cc
            vim.g._ts_has_cli = has_ts

            vim.schedule(function()
                if not has_cc then
                    vim.notify(
                        is_mac
                        and "Treesitter: no compiler found. Install Xcode Command Line Tools with `xcode-select --install`."
                        or "Treesitter: no compiler found. Install a C toolchain for your distro.",
                        vim.log.levels.WARN
                    )
                end

                if not has_ts then
                    vim.notify(
                        is_mac
                        and "Treesitter: `tree-sitter` CLI not found. Install with `brew install tree-sitter`."
                        or "Treesitter: `tree-sitter` CLI not found. Install it with your package manager.",
                        vim.log.levels.INFO
                    )
                end
            end)
        end,
        config = function()
            local ts = require("nvim-treesitter")

            local languages = {
                "bash",
                "c",
                "diff",
                "html",
                "json",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "vim",
                "vimdoc",
                "yaml",
            }

            if vim.g._ts_has_cc then
                table.insert(languages, "latex")
            end

            ts.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            ts.install(languages)

            vim.treesitter.language.register("bash", "zsh")

            local highlight_filetypes = {
                "bash",
                "c",
                "diff",
                "html",
                "json",
                "lua",
                "markdown",
                "python",
                "vim",
                "yaml",
                "zsh",
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = highlight_filetypes,
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })

            local fold_filetypes = {
                "lua",
                "markdown",
                "vim",
                "json",
                "yaml",
                "html",
                "bash",
                "zsh",
                "python",
            }

            -- vim.api.nvim_create_autocmd("FileType", {
            --   pattern = fold_filetypes,
            --   callback = function()
            --     vim.opt_local.foldmethod = "expr"
            --     vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            --   end,
            -- })

            local indent_filetypes = {
                "lua",
                "bash",
                "zsh",
                "json",
                "yaml",
                "html",
                "python",
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = indent_filetypes,
                callback = function()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })

            vim.api.nvim_create_user_command("TSInstalled", function()
                local ok, installed = pcall(ts.get_installed)
                if ok and installed then
                    vim.notify(vim.inspect(installed), vim.log.levels.INFO, { title = "Treesitter installed" })
                else
                    vim.notify("Could not read installed parsers", vim.log.levels.WARN, { title = "Treesitter" })
                end
            end, {})
        end,
    },
}
