local Utils = require("mods.utils")

local toggle_inlay_hint = function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end


vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local wk = require("which-key")
        local function trouble_lsp(mode)
            return function()
                require("trouble").toggle({
                    mode = mode,
                    focus = true,
                })
            end
        end

        wk.add({ "<leader>g", group = "LSP" })
        wk.add({ "<leader>v", group = "LspActions" })
        local opts = { buffer = event.buf }
        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", trouble_lsp("lsp_definitions"), opts)
        vim.keymap.set("n", "gD", trouble_lsp("lsp_declarations"), opts)
        vim.keymap.set("n", "gi", trouble_lsp("lsp_implementations"), opts)
        vim.keymap.set("n", "go", trouble_lsp("lsp_type_definitions"), opts)
        vim.keymap.set("n", "gO", trouble_lsp("lsp_type_definitions"), opts)
        vim.keymap.set("n", "gr", trouble_lsp("lsp_references"), opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
        vim.keymap.set("n", "gci", trouble_lsp("lsp_incoming_calls"), opts)
        vim.keymap.set("n", "gco", trouble_lsp("lsp_outgoing_calls"), opts)
        vim.keymap.set("n", "<leader>vrn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set("n", "<leader>rn", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end, Utils.extend_opts(opts, { expr = true }))
        vim.keymap.set("n", "<leader>vca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
        vim.keymap.set("n", "gq", "<cmd> lua vim.diagnostic.setloclist()<cr>", opts)
        vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.document_symbol()<cr>", opts)
        vim.keymap.set("i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "gti", toggle_inlay_hint, Utils.extend_opts(opts, { desc = "Toggle inlay hints" }))
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.colorcolumn = "50"
    end,
})

-- vim.api.nvim_create_autocmd("BufRead", {
--     callback = function()
--         -- vim.treesitter.start()
--         -- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
--         -- vim.wo[0][0].foldmethod = "expr"
--     end
-- })

-- vim.api.nvim_create_autocmd("BufRead", {
--     callback = function()
--         if Utils.Godot.in_godot_project() then
--             Utils.Godot.start_server()
--             vim.lsp.config("gdscript", {})
--         end
--     end,
-- })
