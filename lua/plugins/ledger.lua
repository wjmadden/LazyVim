return {
  {
    "ledger/vim-ledger",
    ft = { "ledger", "journal", "hledger" },
    config = function()
      vim.g.ledger_bin = "hledger"
      vim.g.ledger_align_at = 50
      vim.g.ledger_default_commodity = "USD"
    end,
  },
}
