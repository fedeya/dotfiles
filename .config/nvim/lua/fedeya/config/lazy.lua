local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "fedeya.plugins" },
  },
  defaults = {
    cond = function(plugin)
      if vim.g.vscode then
        return plugin.vscode or false
      end

      return true
    end
  },
  checker = { enabled = true, notify = false },
  change_detection = {
    notify = false
  },
  install = {
    colorscheme = { 'catppuccin' }
  },
  performance = {
    cache = {
      enabled = true
    },
    rtp = {
      disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
    }
  }
})
