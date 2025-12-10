local Utils = {}
Utils.Godot = {}

--@return table
function Utils.extend_opts(opts, newopts)
	return vim.tbl_extend("keep", opts, newopts)
end

function Utils.Godot.in_godot_project()
	local godot_file = vim.fn.findfile("project.godot", ".;")
	return godot_file ~= ""
end

function Utils.Godot.start_server()
	local project_file = vim.fn.findfile("project.godot", ".;")
	if project_file ~= "" then
		local project_path = vim.fn.fnamemodify(project_file, ":p:h")
		local server_pipe_path = project_path .. "/server.pipe"
		---@diagnostic disable-next-line: undefined-field
		local server_is_running = vim.uv.fs_stat(server_pipe_path) ~= nil
		if not server_is_running then
			vim.notify("Starting new Godot Server")
			vim.fn.serverstart(server_pipe_path)
		end
	end
	return false
end

return Utils
