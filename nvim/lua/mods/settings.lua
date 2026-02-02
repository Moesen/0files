local Settings = {
	path = vim.fn.stdpath("data") .. "/my_vars.json",
}

function Settings.save_var(key, value)
	local data = {}
	local file = io.open(Settings.path, "r")
	if file then
		data = vim.json.decode(file:read("*a")) or {}
		file:close()
	end
	data[key] = value

	file = io.open(Settings.path, "w")
	if file then
		file:write(vim.json.encode(data))
		file:close()
	else
		vim.notify("Data config file not found!", vim.log.levels.ERROR)
	end
end

function Settings.load_var(key)
	local file = io.open(Settings.path, "r")
	if file then
		local data = vim.json.decode(file:read("*a")) or {}
		file:close()
		return data[key]
	end
end

return Settings
