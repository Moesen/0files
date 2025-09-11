local color_mode = "dark"
local function set_color()
	vim.o.bg = color_mode
end

local switch_color = function()
	if color_mode == "dark" then
		color_mode = "light"
	else
		color_mode = "dark"
	end
	set_color()
end

vim.keymap.set("n", "<leader>tt", switch_color)
