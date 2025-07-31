return {
  {
    'norcalli/nvim-colorizer.lua',
    cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
    init = function()
      require("colorizer").setup({})
    end
  }
}
