vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "basic",
      },
    },
  },
})
