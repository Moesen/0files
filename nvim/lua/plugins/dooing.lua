return {
	"atiladefreitas/dooing",
	config = function()
		require("dooing").setup({
			per_project = {
				auto_gitignore = true,
				default_filename = ".dooing.json",
				on_missing = "auto_create",
			},
		})
	end,
}
