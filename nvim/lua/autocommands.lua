vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.colorcolumn = "50"
    end,
})
