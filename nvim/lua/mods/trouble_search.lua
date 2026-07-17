local M = {}

local last_search = nil

local function selected_text()
    local register = vim.fn.getreg("v")
    local register_type = vim.fn.getregtype("v")

    vim.cmd([[noau normal! "vy]])
    local text = vim.fn.getreg("v")

    vim.fn.setreg("v", register, register_type)
    return vim.trim(text:gsub("\n", " "))
end

local function open_qflist()
    for _, entry in ipairs(require("trouble.view").get({ open = true })) do
        entry.view:close()
    end

    require("trouble").open({
        mode = "qflist",
        focus = true,
        win = {
            position = "right",
            size = 0.35,
        },
    })
end

local function rg_base_args()
    return {
        "rg",
        "--color",
        "never",
        "--hidden",
        "--glob",
        "!.git",
    }
end

local function run_rg(args)
    if vim.fn.executable("rg") == 0 then
        vim.notify("ripgrep (rg) is required for Trouble grep", vim.log.levels.ERROR)
        return nil
    end

    local output = vim.fn.systemlist(args)
    local code = vim.v.shell_error

    if code > 1 then
        vim.notify(table.concat(output, "\n"), vim.log.levels.ERROR)
        return nil
    end

    return output
end

local function set_qflist_from_lines(lines, title)
    vim.fn.setqflist({}, "r", {
        title = title,
        lines = lines,
        efm = "%f:%l:%c:%m",
    })
end

local function set_qflist_from_files(files, title)
    local items = {}

    for _, file in ipairs(files) do
        table.insert(items, {
            filename = file,
            lnum = 1,
            col = 1,
            text = file,
        })
    end

    vim.fn.setqflist({}, "r", {
        title = title,
        items = items,
    })
end

function M.grep(pattern)
    pattern = vim.trim(pattern or "")

    if pattern == "" then
        vim.ui.input({ prompt = "Rg: " }, function(input)
            if input and vim.trim(input) ~= "" then
                M.grep(input)
            end
        end)
        return
    end

    local args = rg_base_args()
    vim.list_extend(args, {
        "--vimgrep",
        "--smart-case",
        "--",
        pattern,
    })

    local lines = run_rg(args)
    if not lines then
        return
    end

    if vim.tbl_isempty(lines) then
        vim.notify(("No matches for %q"):format(pattern), vim.log.levels.INFO)
        return
    end

    last_search = pattern
    set_qflist_from_lines(lines, ("rg: %s"):format(pattern))
    open_qflist()
end

function M.grep_selection()
    M.grep(selected_text())
end

function M.files(query)
    if query == nil then
        vim.ui.input({ prompt = "Files: " }, function(input)
            if input ~= nil then
                M.files(input)
            end
        end)
        return
    end

    query = vim.trim(query)

    local files = run_rg(vim.list_extend(rg_base_args(), { "--files" }))
    if not files then
        return
    end

    local filtered = {}
    local needle = query:lower()
    for _, file in ipairs(files) do
        if query == "" or file:lower():find(needle, 1, true) then
            table.insert(filtered, file)
        end
    end

    if vim.tbl_isempty(filtered) then
        vim.notify(("No files for %q"):format(query), vim.log.levels.INFO)
        return
    end

    set_qflist_from_files(filtered, ("files: %s"):format(query))
    open_qflist()
end

function M.last_grep()
    if not last_search then
        vim.notify("No Trouble grep search yet", vim.log.levels.INFO)
        return
    end

    M.grep(last_search)
end

return M
