vim.cmd('packadd nvim.undotree')
vim.cmd('packadd nvim.difftool')

vim.keymap.set("n", "<leader>u",
  function()
    require("undotree").open()
  end
)
