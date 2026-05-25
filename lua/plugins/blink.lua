-- return {}
return {
  "saghen/blink.cmp",
  opts = {
    sources = {
      -- Your default active sources for ordinary files
      default = { "lsp", "path", "snippets", "buffer" },

      -- Enable the custom omnifunc completion for hledger files
      per_filetype = {
        ledger = { "lsp", "path", "snippets", "buffer", "omni" },
      },
    },
  },
}
