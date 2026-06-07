local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("highlightyank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Set filetype ruby for files that are not recognized by vim
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    -- Podfiles
    "*.podspec",
    "Podfile",

    -- Fastlane
    "Appfile",
    "Fastfile",
    "Matchfile",
    "Deliverfile",
    "Snapfile",
    "Supplyfile",
    "Gymfile",
    "Frameitfile",
    "Pemfile",
    "Sighfile",
    "Rapidfile",
    "Scanfile",
    "Cerfile",
    "Provisioningfile",
  },
  command = "set filetype=ruby",
})

-- Set filetpe terraform
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*.tf",
    "*.tfvars",
  },
  command = "set filetype=terraform",
})

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*.mdx",
  },
  command = "set filetype=markdown",
})

-- Open help files in a vertical split
autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    ".env.*",
    ".env",
  },
  command = "set filetype=sh",
})

-- Fix conceallevel for json files
autocmd({ "FileType" }, {
  pattern = { "json", "jsonc", "json5", "http" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

autocmd("LspAttach", {
  callback = function(event)
    -- vim.keymap.set("n", "gh", vim.lsp.buf.hover, {
    --   desc = "Hover Doc",
    --   buffer = event.bufnr,
    -- })

    vim.keymap.set("n", "K", vim.lsp.buf.hover, {
      desc = "Hover Doc",
      buffer = event.bufnr,
    })

    vim.keymap.set("n", "ga", function()
      vim.lsp.buf.code_action()
    end, {
      desc = "Code Action",
      buffer = event.bufnr,
    })

    vim.keymap.set("n", "<leader>i", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, {
      desc = "Toggle inlay hints",
      buffer = event.bufnr,
    })

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client.name == "eslint" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = event.buf,
        command = "LspEslintFixAll",
      })
    end
  end,
})

autocmd({ "FileType" }, {
  pattern = {
    "json.kulala_ui",
  },
  callback = function()
    vim.opt_local.relativenumber = true
    vim.opt_local.conceallevel = 0
  end,
})

autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd([[clearjumps]])
  end,
})

autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value or {}
    if not value.kind then return end

    local status = value.kind == "end" and 0 or 1
    local percent = value.percentage or 0

    local osc_seq = string.format("\27]9;4;%d;%d\a", status, percent)

    if os.getenv("TMUX") then
      osc_seq = string.format("\27Ptmux;\27%s\27\\", osc_seq)
    end

    io.stdout:write(osc_seq)
    io.stdout:flush()
  end,
})

autocmd("FileType", {
  pattern = "nvim-undotree",
  callback = function(ev)
    vim.keymap.set("n", "q", ":q<CR>", { buffer = ev.buf, desc = "Close Undotree", silent = true })
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "msg",
--   callback = function()
--     local ui2 = require("vim._core.ui2")
--     local win = ui2.wins and ui2.wins.msg
--     if win and vim.api.nvim_win_is_valid(win) then
--       vim.api.nvim_set_option_value(
--         "winhighlight",
--         "Normal:NormalFloat,FloatBorder:FloatBorder",
--         { scope = "local", win = win }
--       )
--     end
--   end,
-- })

-- local ui2 = require("vim._core.ui2")
-- local msgs = require("vim._core.ui2.messages")
-- local orig_set_pos = msgs.set_pos
-- msgs.set_pos = function(tgt)
--   orig_set_pos(tgt)
--   if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
--     pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
--       relative = "editor",
--       anchor = "NE",
--       row = 1,
--       col = vim.o.columns - 1,
--       border = "rounded",
--     })
--   end
-- end

-- autocmd('LspProgress', {
--   callback = function(ev)
--     local value = ev.data.params.value
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--
--     vim.api.nvim_echo({ { value.message or 'done' } }, false, {
--       id = 'lsp.' .. ev.data.client_id,
--       kind = 'progress',
--       source = 'vim.lsp',
--       title = "[" .. client.name .. "] " .. value.title,
--       status = value.kind ~= 'end' and 'running' or 'success',
--       percent = value.percentage,
--     })
--   end,
-- })

-- require('fedeya.config.autocmds.macro')
