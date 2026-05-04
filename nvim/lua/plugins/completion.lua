return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "BufReadPre", "BufNewFile", "BufEnter" },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            "L3MON4D3/LuaSnip",
        },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            local cmp = require("cmp")
            local completion_window = cmp.config.window.bordered({
                col_offset = -1,
                side_padding = 0,
                scrollbar = false,
                max_height = 12,
            })
            local documentation_window = vim.tbl_deep_extend("force", cmp.config.window.bordered(), {
                max_width = math.floor(vim.o.columns * 0.45),
                max_height = 16,
            })

            cmp.setup({
                preselect = cmp.PreselectMode.Item,
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                window = {
                    completion = completion_window,
                    documentation = documentation_window,
                },
                formatting = {
                    fields = { "abbr", "kind", "menu" },
                    format = function(entry, vim_item)
                        local max_abbr = math.floor(vim.o.columns * 0.28)
                        local max_menu = math.floor(vim.o.columns * 0.28)

                        if #vim_item.abbr > max_abbr then
                            vim_item.abbr = vim_item.abbr:sub(1, max_abbr - 1) .. "…"
                        end

                        local source = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snip]",
                            buffer = "[Buf]",
                            path = "[Path]",
                        })[entry.source.name] or ("[" .. entry.source.name .. "]")

                        local detail = vim_item.menu
                        if detail and detail ~= "" then
                            vim_item.menu = string.format("%s %s", source, detail)
                        else
                            vim_item.menu = source
                        end

                        if #vim_item.menu > max_menu then
                            vim_item.menu = vim_item.menu:sub(1, max_menu - 1) .. "…"
                        end

                        return vim_item
                    end,
                },
                sources = {
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "luasnip", keyword_length = 3 },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<Enter>"] = cmp.mapping.confirm({
                        select = true,
                    }),

                    -- Super tab
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        local luasnip = require("luasnip")
                        local col = vim.fn.col(".") - 1

                        if cmp.visible() then
                            cmp.select_next_item({ behavior = "select" })
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                            fallback()
                        else
                            cmp.complete()
                        end
                    end, { "i", "s" }),
                    -- Super shift tab
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        local luasnip = require("luasnip")

                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = "select" })
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
            })
        end,
    },
}
