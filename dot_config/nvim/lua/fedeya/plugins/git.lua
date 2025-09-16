return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      current_line_blame = true,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        -- map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
        -- map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        -- map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
        -- map("n", "<leader>ghb", function()
        --   gs.blame_line({ full = true })
        -- end, "Blame Line")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>gD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gread", "Gwrite" },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
  },

  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
      {
        "<leader>gn",
        "<Cmd>Neogit<CR>",
        desc = "Neogit",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "ibhagwan/fzf-lua",       -- optional picking
    },
    opts = {
      --- @type NeogitConfig
      integrations = {
        diffview = true,
        fzf_lua = true,
      },
      kind = "floating",
      commit_editor = {
        kind = "floating",
      },
    },
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    config = true,
  },
}
