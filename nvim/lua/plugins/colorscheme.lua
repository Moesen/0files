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
        -- morhetz/gruvbox predates these Neovim and which-key groups.
        -- Reapply links after every theme load, including background toggles.
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("GruvboxHighlights", { clear = true }),
            pattern = "gruvbox",
            callback = function()
                local links = {
                    NormalFloat = "Normal",
                    FloatBorder = "GruvboxBg3",
                    FloatTitle = "GruvboxGreenBold",
                    DiagnosticError = "GruvboxRed",
                    DiagnosticWarn = "GruvboxYellow",
                    DiagnosticInfo = "GruvboxBlue",
                    DiagnosticHint = "GruvboxAqua",
                    DiagnosticOk = "GruvboxGreen",
                    -- Explicit links also prevent which-key from substituting
                    -- mini.icons defaults when that plugin is loaded.
                    WhichKeyIcon = "GruvboxBlue",
                    WhichKeyIconAzure = "GruvboxBlue",
                    WhichKeyIconBlue = "GruvboxBlue",
                    WhichKeyIconCyan = "GruvboxAqua",
                    WhichKeyIconGreen = "GruvboxGreen",
                    WhichKeyIconGrey = "GruvboxFg4",
                    WhichKeyIconOrange = "GruvboxOrange",
                    WhichKeyIconPurple = "GruvboxPurple",
                    WhichKeyIconRed = "GruvboxRed",
                    WhichKeyIconYellow = "GruvboxYellow",
                }
                for group, target in pairs(links) do
                    vim.api.nvim_set_hl(0, group, { link = target })
                end
            end,
        })
        vim.cmd.colorscheme("gruvbox")
    end,
}
