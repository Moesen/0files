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

Utils.path = {}
function Utils.path.current_buffer_file_path()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == "" or bufname:match("^%a+://") then
        return nil
    end

    local absolute_path = vim.fn.fnamemodify(bufname, ":p")
    local stat = vim.uv.fs_stat(absolute_path)
    if stat and stat.type == "file" then
        return absolute_path
    end

    return nil
end

function Utils.path.path_is_within_root(path, root)
    local normalized_path = vim.fs.normalize(path)
    local normalized_root = vim.fs.normalize(vim.fn.fnamemodify(root, ":p"))
    return normalized_path == normalized_root
        or normalized_path:sub(1, #normalized_root + 1) == normalized_root .. "/"
end

function Utils.path.current_buffer_reveal_opts(root)
    local filepath = Utils.path.current_buffer_file_path()
    if not filepath then
        return {}
    end

    local reveal_root = root or vim.fn.getcwd()
    if Utils.path.path_is_within_root(filepath, reveal_root) then
        return { reveal_file = filepath }
    end

    return {}
end

function Utils.path.current_file_repo_root(filepath)
    local dir = vim.fn.fnamemodify(filepath, ":h")
    local git_root = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })[1]
    if vim.v.shell_error == 0 and git_root and git_root ~= "" then
        return git_root
    end
    return nil
end

function Utils.path.format_python_module(filepath, repo_root)
    local base_path = repo_root and vim.fs.relpath(repo_root, filepath) or filepath
    if not base_path or base_path == "" then
        return filepath
    end

    local module_path = base_path:gsub("%.py$", ""):gsub("/", ".")
    module_path = module_path:gsub("^%.+", "")
    module_path = module_path:gsub("%.__init__$", "")

    if module_path == "" then
        return repo_root or filepath
    end

    return module_path
end

function Utils.path.copy_current_file_path()
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath == "" then
        vim.notify("Current buffer has no file path", vim.log.levels.WARN)
        return
    end

    local absolute_path = vim.fn.fnamemodify(filepath, ":p")
    local repo_root = Utils.path.current_file_repo_root(absolute_path)
    local copied_path

    if absolute_path:match("%.py$") then
        copied_path = Utils.path.format_python_module(absolute_path, repo_root)
    elseif repo_root then
        copied_path = "/" .. vim.fs.relpath(repo_root, absolute_path)
    else
        copied_path = absolute_path
    end

    vim.fn.setreg("+", copied_path)
    vim.notify("Copied path: " .. copied_path)
end

return Utils
