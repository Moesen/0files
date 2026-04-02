return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    init = function()
        if vim.fn.executable("tree-sitter") == 1 then
            return
        end

        vim.schedule(function()
            vim.notify(
                "nvim-treesitter needs the `tree-sitter` CLI on this version. Install it with `brew install tree-sitter-cli` for :TSInstall to work.",
                vim.log.levels.WARN
            )
        end)
    end,
}
