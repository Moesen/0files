vim.keymap.set(
    "n",
    "<leader>kt",
    'ciw{% trans "<C-r>"" %}<Esc>',
    { remap = false, desc = "Make into trans text" }
)

vim.keymap.set("v", "<leader>kt", function()
    local mode = vim.fn.mode()
    vim.cmd('normal! "xy')
    local text = vim.fn.getreg("x")
    if mode == "V" then
        text = text:gsub("^%s+", ""):gsub("%s+$", "")
    end
    vim.fn.setreg("x", '{% trans "' .. text .. '" %}')
    vim.cmd('normal! gv"xp')
end, { remap = false })
