return {
  {
    "ledger/vim-ledger",
    ft = { "ledger", "journal", "hledger" },
    init = function()
      vim.g.ledger_bin = "hledger"
      vim.g.ledger_is_hledger = 1
      vim.g.ledger_align_at = 75
      vim.g.ledger_fold_level = 1
      vim.g.ledger_default_commodity = "USD"
      vim.g.ledger_accounts_command = "hledger accounts -f accounts.journal"
      vim.g.ledger_fuzzy_account_completion = 1
      vim.g.ledger_date_format = "%Y-%m-%d"
    end,
  },
}
