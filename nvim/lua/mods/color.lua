local Color = {
	bg_mode = "dark",
}

--@private
function Color.set_bg()
	vim.o.bg = Color.bg_mode
end

function Color.change_bg()
	if Color.bg_mode == "dark" then
		Color.bg_mode = "light"
	else
		Color.bg_mode = "dark"
	end
	Color.set_bg()
end

return Color
