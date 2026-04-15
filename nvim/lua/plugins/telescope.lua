local function grep_selected_text()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg("v")
	text = text:gsub("\n", " "):gsub("^%s+", ""):gsub("%s+$", "")
	require("telescope").extensions.live_grep_args.live_grep_args({
		default_text = text,
	})
end

local function loaded_todo_picker(opts)
	opts = opts or {}

	require("todo-comments")

	local Config = require("todo-comments.config")
	local Highlight = require("todo-comments.highlight")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local make_entry = require("telescope.make_entry")

	local bufs = {}
	if opts.current_buffer then
		bufs = { vim.api.nvim_get_current_buf() }
	else
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
				local name = vim.api.nvim_buf_get_name(buf)
				local buftype = vim.bo[buf].buftype
				if name ~= "" and buftype == "" then
					table.insert(bufs, buf)
				end
			end
		end
	end

	local results = {}
	for _, buf in ipairs(bufs) do
		local filename = vim.api.nvim_buf_get_name(buf)
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

		for idx, line in ipairs(lines) do
			local start_col, _, kw = Highlight.match(line)
			if start_col and kw then
				if Config.options.highlight.comments_only and not Highlight.is_comment(buf, idx - 1, start_col - 1) then
					kw = nil
				end
			end

			if kw then
				table.insert(results, string.format("%s:%d:%d:%s", filename, idx, start_col, line))
			end
		end
	end

	if vim.tbl_isempty(results) then
		vim.notify("No todos found", vim.log.levels.INFO)
		return
	end

	local entry_maker = make_entry.gen_from_vimgrep(opts)
	pickers
		.new(opts, {
			prompt_title = opts.current_buffer and "Todo (Current File)" or "Todo (Loaded Buffers)",
			finder = finders.new_table({
				results = results,
				entry_maker = function(line)
					local entry = entry_maker(line)
					entry.display = function(item)
						local display = string.format("%s:%s:%s ", item.filename, item.lnum, item.col)
						local text = item.text
						local start_col, end_col, kw = Highlight.match(text)
						local hl = {}

						if start_col and end_col and kw then
							kw = Config.keywords[kw] or kw
							local icon = Config.options.keywords[kw].icon or " "
							display = icon .. " " .. display
							table.insert(hl, { { 0, #icon + 1 }, "TodoFg" .. kw })
							text = vim.trim(text:sub(start_col))
							table.insert(hl, {
								{ #display, #display + end_col - start_col + 2 },
								"TodoBg" .. kw,
							})
							table.insert(hl, {
								{ #display + end_col - start_col + 1, #display + end_col + 1 + #text },
								"TodoFg" .. kw,
							})
							display = display .. " " .. text
						end

						return display, hl
					end
					return entry
				end,
			}),
			previewer = conf.grep_previewer(opts),
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			version = "^1.1.0",
		},
	},
	keys = {
		{ "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{
			"<leader>pt",
			function()
				loaded_todo_picker({ current_buffer = true })
			end,
			desc = "Todo in current file",
		},
		{
			"<leader>pT",
			function()
				loaded_todo_picker()
			end,
			desc = "Todo in loaded buffers",
		},
		{
			"<leader>pg",
			function()
				require("telescope").extensions.live_grep_args.live_grep_args()
			end,
			desc = "Live Grep",
		},
		{ "<leader>pd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		{ "<leader>pc", "<cmd>Telescope spell_suggest<cr>", desc = "Spell Suggest" },
		{
			"<leader>pg",
			grep_selected_text,
			mode = "v",
			desc = "Grep selected text",
		},
		{
			"<leader>pG",
			grep_selected_text,
			mode = "v",
			desc = "Grep selected text",
		},
	},
	opts = function()
		local lga_actions = require("telescope-live-grep-args.actions")

		return {
			defaults = {
				layout_strategy = "horizontal",
				sorting_strategy = "ascending",
				prompt_prefix = "   ",
				selection_caret = "  ",
				path_display = { "truncate" },
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.65,
					},
					width = 0.95,
					height = 0.92,
					preview_cutoff = 80,
				},
				preview = {
					treesitter = false,
				},
				mappings = {
					i = {
						["<C-k>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					},
				},
			},
			pickers = {
				find_files = {},
				live_grep = {
					previewer = true,
					additional_args = function()
						return { "--trim" }
					end,
				},
				spell_suggest = {
					theme = "cursor",
				},
				diagnostics = {
					cwd_only = true,
				},
			},
			extensions = {
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							["<C-k>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
						},
					},
				},
			},
		}
	end,
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("live_grep_args")
		telescope.load_extension("grapple")
	end,
}
