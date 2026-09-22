local Settings = require("mods.settings")

local Color = {
    bg_mode = Settings.load_var("bg_mode") or "dark",
}

function Color.set_bg()
    -- Read the current scheme BEFORE flipping bg: setting 'background' clears
    -- g:colors_name as a side effect (Vim re-runs :hi clear on bg change).
    local name = vim.g.colors_name
    vim.o.bg = Color.bg_mode
    if not name then return end
    -- Gruvbox uses the same scheme name for both background modes.
    vim.cmd.colorscheme(name)
end

function Color.change_bg()
    if Color.bg_mode == "dark" then
        Color.bg_mode = "light"
        Settings.save_var("bg_mode", "light")
    else
        Color.bg_mode = "dark"
        Settings.save_var("bg_mode", "dark")
    end
    Color.set_bg()
end

return Color
