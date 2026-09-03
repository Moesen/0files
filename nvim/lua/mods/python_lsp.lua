local Settings = require("mods.settings")

local M = {}

M.servers = {
    "basedpyright",
    "pyrefly",
    "ty",
}

local settings_key = "python_lsp_enabled"
local state

local function default_state()
    return {
        basedpyright = true,
        pyrefly = false,
        ty = false,
    }
end

local function load_state()
    local saved = Settings.load_var(settings_key)
    local loaded = default_state()

    if type(saved) ~= "table" then
        return loaded
    end

    for _, server in ipairs(M.servers) do
        if type(saved[server]) == "boolean" then
            loaded[server] = saved[server]
        end
    end

    return loaded
end

local function current_state()
    if state == nil then
        state = load_state()
    end

    return state
end

local function is_supported(server)
    return vim.list_contains(M.servers, server)
end

function M.is_enabled(server)
    return current_state()[server] == true
end

function M.set_enabled(server, enabled)
    if not is_supported(server) then
        error("Unsupported Python LSP: " .. server)
    end

    current_state()[server] = enabled
    Settings.save_var(settings_key, state)
    vim.lsp.enable(server, enabled)
end

function M.apply()
    for _, server in ipairs(M.servers) do
        vim.lsp.enable(server, M.is_enabled(server))
    end
end

local function make_finder()
    local finders = require("telescope.finders")

    return finders.new_table({
        results = M.servers,
        entry_maker = function(server)
            return {
                value = server,
                ordinal = server,
                display = function(entry)
                    local enabled = M.is_enabled(entry.value)
                    local marker = enabled and "[on] " or "[off]"
                    local highlight = enabled and "DiagnosticOk" or "Comment"

                    return string.format("%-5s %s", marker, entry.value), {
                        { { 0, #marker }, highlight },
                    }
                end,
            }
        end,
    })
end

function M.pick()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local config = require("telescope.config").values
    local pickers = require("telescope.pickers")

    pickers
        .new({}, {
            prompt_title = "Python LSPs (<CR> toggles)",
            finder = make_finder(),
            sorter = config.generic_sorter({}),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    if selection == nil then
                        return
                    end

                    M.set_enabled(selection.value, not M.is_enabled(selection.value))
                    action_state.get_current_picker(prompt_bufnr):refresh(make_finder(), {
                        reset_prompt = false,
                    })
                end)

                return true
            end,
        })
        :find()
end

function M.setup()
    M.apply()

    if vim.fn.exists(":PythonLspPicker") == 0 then
        vim.api.nvim_create_user_command("PythonLspPicker", M.pick, {
            desc = "Enable or disable Python language servers",
        })
    end
end

return M
