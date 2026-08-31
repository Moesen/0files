local function get_indent_level()
    local current_line = vim.api.nvim_get_current_line()
    local indent_str = current_line:match("^%s+") or ""
    local indent_count = 0
    local expandtab = vim.bo.expandtab
    if expandtab then
        indent_count = math.floor(#indent_str / vim.bo.shiftwidth)
    else
        indent_count = select(2, string.gsub(indent_str, "\t", ""))
    end
    return "󱁐 " .. indent_count
end

local function get_filename()
    local filename = vim.api.nvim_buf_get_name(0)
    if filename == "" then
        return "[No Name]"
    end

    local repo_root = vim.fs.root(0, ".git")
    if repo_root then
        return vim.fs.relpath(repo_root, filename) or vim.fn.fnamemodify(filename, ":~:.")
    end

    return vim.fn.fnamemodify(filename, ":~:.")
end

return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            sections = {
                lualine_a = { { "mode", icons_enable = true } },
                lualine_b = {
                    { "lsp_status" },
                    {
                        function() return vim.g.llama_server_running and "󰚩 on" or "󰚩 off" end,
                        color = function()
                            return { fg = vim.g.llama_server_running and "#a6e3a1" or "#6c7086" }
                        end,
                    },
                },
                lualine_c = {
                    {
                        "branch",
                        fmt = function(str)
                            local route_match = str:match("^(%w+)/(^-)+")
                            if route_match then
                                return str:match("^(%w+)/([^-])+)")
                            end

                            local number_match = str:match("(%d+)")
                            if number_match then
                                return "#" .. number_match
                            end
                            return str
                        end,
                    },
                },
                lualine_x = { { "filetype", icon_only = true, icon = { align = "right" } } },
                lualine_y = { "progress" },
                lualine_z = { get_indent_level, "searchcount", "selectioncount", "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            winbar = {
                lualine_c = {
                    { get_filename },
                },
            },
            inactive_winbar = {
                lualine_c = {
                    { get_filename },
                },
            },
        },
    },
}
