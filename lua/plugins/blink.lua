-- return {}
return {
  "saghen/blink.cmp",
  keys = {
    -- Intercepts "jj" in Insert mode, cancels blink, and leaves Insert Mode
    {
      "jj",
      function()
        require("blink.cmp").cancel()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", false)
      end,
      mode = "i",
      desc = "Escape and Cancel Completion",
    },
  },
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
