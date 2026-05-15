local function start_llama_server_probe()
    local uv = vim.uv or vim.loop
    vim.g.llama_server_running = false
    local function probe()
        local tcp = uv.new_tcp()
        local timeout = uv.new_timer()
        timeout:start(500, 0, function()
            if not tcp:is_closing() then tcp:close() end
        end)
        tcp:connect("127.0.0.1", 8012, function(err)
            vim.schedule(function() vim.g.llama_server_running = err == nil end)
            timeout:stop()
            timeout:close()
            if not tcp:is_closing() then tcp:close() end
        end)
    end
    local timer = uv.new_timer()
    timer:start(0, 3000, vim.schedule_wrap(probe))
end

local function toggle_llama_fim()
    vim.fn["llama#toggle_auto_fim"]()
    local enabled = vim.g.llama_config and vim.g.llama_config.auto_fim
    vim.notify("llama FIM " .. (enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end

return {
    {
        "ggml-org/llama.vim",
        event = "VeryLazy",
        init = function()
            vim.g.llama_config = {
                endpoint_fim = "http://127.0.0.1:8012/infill",
                show_info = 0,
                auto_fim = false,
                ring_n_chunks = 0,
                n_prefix = 128,
                n_suffix = 32,
                keymap_fim_trigger = "",
                keymap_fim_accept_word = "",
            }
            start_llama_server_probe()
        end,
        config = function()
            vim.keymap.set("i", "<M-a>", function()
                vim.fn["llama#fim_inline"](false, false)
            end, { desc = "llama: trigger FIM suggestion" })
            vim.keymap.set("n", "<leader>llt", toggle_llama_fim, { desc = "llama: toggle auto FIM" })
        end,
    },
    -- {
    --     "greggh/claude-code.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim", -- Required for git operations
    --     },
    --     config = function()
    --         require("claude-code").setup({
    --             window = {
    --                 position = "rightbelow vsplit"
    --             }
    --         })
    --     end
    -- }

}
