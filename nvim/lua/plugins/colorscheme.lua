return {
    "morhetz/gruvbox",
    lazy = false,
    priority = 1000,
    init = function()
        vim.g.gruvbox_contrast_dark = "medium"
        vim.g.gruvbox_contrast_light = "medium"
        vim.o.background = require("mods.color").bg_mode
    end,
    config = function()
        vim.cmd.colorscheme("gruvbox")
    end,
}
