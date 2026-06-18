vim.keymap.set("n", "<leader>so", function()
        vim.cmd("tabnew")
        vim.bo.filetype = 'python'
        vim.bo.buftype = 'nofile'
        vim.bo.bufhidden = 'hide'
    end,
    { desc = 'Open empty python scratchpad buffer' }
)

return {
    {
        'goerz/jupytext.nvim',
        version = '0.2.0',
        opts = {}, -- see Options
    },
    {
        "Vigemus/iron.nvim",
        config = function()
            require("iron.core").setup({
                config = {
                    repl_definition = {
                        python = require("iron.fts.python").ipython
                    },
                    repl_open_cmd = require("iron.view").right(80)
                },
                keymaps = {
                    send_motion = "<leader>sc",
                    visual_send = "<leader>sc",
                    send_file = "<leader>sf",
                    send_line = "<leader>sl",
                    send_until_cursor = "<leader>su"
                }
            })
        end
    }
}
