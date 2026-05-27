-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>mh", function()
  -- Mapping: Feb (02) -> a, Mar (03) -> b ... Dec (12) -> k
  local months = {
    ["-02-"] = "a",
    ["-03-"] = "b",
    ["-04-"] = "c",
    ["-05-"] = "d",
    ["-06-"] = "e",
    ["-07-"] = "f",
    ["-08-"] = "g",
    ["-09-"] = "h",
    ["-10-"] = "i",
    ["-11-"] = "j",
    ["-12-"] = "k",
  }

  local save_cursor = vim.fn.getpos(".")

  -- Clear marks a-k to prevent jumping to old data
  for _, mark in pairs(months) do
    vim.cmd("delmarks " .. mark)
  end

  -- Start at the very top
  vim.cmd("normal! gg")

  for pattern, mark in pairs(months) do
    -- Search only at the start of lines (^) to match hledger dates
    -- 'w' (wrap) is OFF to find the first occurrence in the file
    local res = vim.fn.search("^\\d\\{4}" .. pattern, "w")
    if res ~= 0 then
      -- Jump UP one line to the blank line before setting the mark
      vim.cmd("normal! km" .. mark)
    end
    -- Reset to top for the next search
    vim.cmd("normal! gg")
  end

  -- Final Step: Jump to the 'a' mark (End of Jan/Start of Feb)
  -- we use pcall in case February doesn't exist in the file yet
  local status = pcall(function()
    vim.cmd("normal! 'a")
  end)

  if status then
    print("Marks set! Jumped to mark 'a' (End of January).")
  else
    print("Marks set, but February (mark 'a') was not found.")
  end
end, { desc = "Mark blank line above first entry of each month (Feb-Dec)" })
