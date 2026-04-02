-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Force Treesitter to use the 'json' parser for 'jsonc' files
vim.treesitter.language.register("json", "jsonc")
