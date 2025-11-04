return {
  "folke/snacks.nvim",

  opts = function(_, opts)
    table.insert(opts.dashboard.preset.keys, 10, { icon = "󰟾 ", key = "m", desc = "Mason", action = ":Mason" })
  end,
}
