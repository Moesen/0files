return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    name = "kanagawa",
    config = function()
      vim.cmd([[colorscheme kanagawa]])
    end,
  }
}
