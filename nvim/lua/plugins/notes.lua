return {
    {
        "obsidian-nvim/obsidian.nvim",
        version = "*", -- use latest release, remove to use latest commit
        opts = {
            legacy_commands = false,
            workspaces = {
                {
                    name = "Supplios",
                    path = "~/Vaults/Supplios/",
                },
            },
            picker = {
                name = "telescope.nvim"
            }
        },
    },
}
