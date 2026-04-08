return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = false,
                enable_git_status = true,
                enable_diagnostics = true,
                popup_border_style = "rounded",
                sort_case_insensitive = true,
                default_component_configs = {
                    container = {
                        enable_character_fade = true,
                    },
                    indent = {
                        indent_size = 2,
                        padding = 1,
                        with_expanders = true,
                        expander_collapsed = "",
                        expander_expanded = "",
                    },
                    modified = {
                        symbol = "●",
                    },
                    git_status = {
                        symbols = {
                            added = "+",
                            deleted = "x",
                            modified = "~",
                            renamed = "r",
                            untracked = "?",
                            ignored = ".",
                            unstaged = "!",
                            staged = "s",
                            conflict = "c",
                        },
                    },
                },
                window = {
                    position = "left",
                    width = 48,
                    mappings = {
                        ["<space>"] = "none",
                        ["<cr>"] = "open",
                        ["l"] = "open",
                        ["h"] = "close_node",
                        ["v"] = "open_vsplit",
                        ["s"] = "open_split",
                        ["q"] = "close_window",
                        ["R"] = "refresh",
                    },
                },
                filesystem = {
                    bind_to_cwd = true,
                    follow_current_file = {
                        enabled = true,
                        leave_dirs_open = false,
                    },
                    hijack_netrw_behavior = "open_current",
                    use_libuv_file_watcher = true,
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                    window = {
                        mappings = {
                            ["."] = "set_root",
                            ["H"] = "toggle_hidden",
                            ["/"] = "fuzzy_finder",
                            ["f"] = "filter_on_submit",
                            ["<bs>"] = "navigate_up",
                        },
                    },
                },
            })

            local command = require("neo-tree.command")

            local function open_tree(opts)
                command.execute(vim.tbl_extend("force", {
                    source = "filesystem",
                    position = "left",
                    action = "show",
                    reveal = true,
                }, opts or {}))
            end

            vim.api.nvim_create_autocmd("VimEnter", {
                desc = "Open Neo-tree on startup",
                callback = function(data)
                    if vim.fn.argc() == 0 then
                        open_tree()
                        return
                    end

                    local path = data.file ~= "" and data.file or vim.fn.argv(0)
                    if path == "" then
                        open_tree()
                        return
                    end

                    local stat = vim.uv.fs_stat(path)
                    if stat and stat.type == "directory" then
                        open_tree({ dir = vim.fn.fnamemodify(path, ":p") })
                        return
                    end

                    open_tree()
                end,
            })
        end,
    },
}
