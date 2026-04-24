local keymap_path = vim.fn.stdpath("config") .. '/lua/keymaps'

for _, file in ipairs(vim.fn.readdir(keymap_path)) do
    if file ~= 'init.lua' and file:match("%.lua$") then
        local module_name = "keymaps." .. file:gsub("%.lua$", "")
        local ok, err = pcall(require, module_name)
        if not ok then
            vim.notify("Failed to load " .. module_name .. ": " .. err, vim.log.levels.ERROR)
        end
    end
end
