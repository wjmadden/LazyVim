-- Helper function to convert YYYY-MM-DD, YYYY/MM/DD, or YYYY.MM.DD to a comparable number
local function date_to_number(date_str)
  if not date_str then
    return nil
  end
  local y, m, d = date_str:match("^(%d%d%d%d)[-/. ](%d%d)[-/. ](%d%d)")
  if y and m and d then
    return tonumber(y .. m .. d)
  end
  return nil
end

local function find_uncleared_transactions(account_filter, date_filter)
  -- Default variables
  account_filter = account_filter or ""
  local closing_date_num = date_to_number(date_filter)

  -- Smart argument swap: If the user only provides a date string as the first argument
  if account_filter:match("^%d%d%d%d[-/. ]%d%d[-/. ]%d%d") and not date_filter then
    closing_date_num = date_to_number(account_filter)
    account_filter = ""
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local qf_items = {}

  local date_pattern = "^(%d%d%d%d[-/. ]%d%d[-/. ]%d%d)"
  local i = 1

  while i <= #lines do
    local line = lines[i]
    local date_match = line:match(date_pattern)

    if date_match then
      local current_tx_date_num = date_to_number(date_match)
      local rest = line:sub(#date_match + 1):match("^%s*(.*)") or ""

      -- 1. Verify it's an unmarked transaction header
      local is_unmarked = not (rest:match("^[xX*!]"))

      -- 2. Verify it fits within our closing date cutoff
      local is_within_date = true
      if closing_date_num and current_tx_date_num then
        is_within_date = (current_tx_date_num <= closing_date_num)
      end

      if is_unmarked and is_within_date then
        local tx_start_lnum = i
        local tx_header = line
        local match_found = false
        local amount = "0.00"

        -- Look ahead at the postings of this transaction to match the account
        local j = i + 1
        while j <= #lines do
          local next_line = lines[j]

          if next_line:match(date_pattern) then
            break
          end

          if next_line:match("^%s+") and next_line:match(account_filter) then
            match_found = true
            amount = next_line:match("  [-]?%d+.%d%d")
          end

          j = j + 1
        end

        if match_found then
          table.insert(qf_items, {
            bufnr = bufnr,
            lnum = tx_start_lnum,
            col = 1,
            text = tx_header .. " " .. amount,
            -- type = "W",
          })
        end

        i = j - 1
      end
    end
    i = i + 1
  end

  -- Display summary feedback based on what filters were used
  local filter_desc = "'" .. account_filter .. "'"
  if closing_date_num then
    filter_desc = filter_desc .. " up to " .. (date_filter or account_filter)
  end

  if #qf_items > 0 then
    vim.fn.setqflist(qf_items, "r")
    vim.cmd("copen")
    print("Found " .. #qf_items .. " uncleared transactions for " .. filter_desc .. ".")
  else
    vim.fn.setqflist({}, "r")
    vim.cmd("cclose")
    print("No uncleared transactions found for " .. filter_desc .. ". ??")
  end
end

-- Update user command to handle multiple whitespace-separated arguments
vim.api.nvim_create_user_command("HReconcile", function(opts)
  -- Split arguments by space
  local args = vim.split(opts.args, "%s+", { trimempty = true })
  find_uncleared_transactions(args[1], args[2])
end, { nargs = "?" })

-- Updated Keymap: Prompts you for both parameters sequentially
-- vim.keymap.set("n", "<leader>hu", function()
--   local account = vim.fn.input("Filter by account (optional): ")
--   local cutoff_date = vim.fn.input("Statement closing date YYYY-MM-DD (optional): ")
--   find_uncleared_transactions(account, cutoff_date)
-- end, { desc = "Find uncleared hledger transactions with date cutoff" })
