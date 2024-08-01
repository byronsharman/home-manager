vim.cmd("colorscheme retrobox")

vim.opt.hlsearch = false

-- spell-checking
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- tab stuff
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = -1
vim.opt.smarttab = true

-- highlight yanked text for 200ms
vim.cmd[[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=200})
  augroup END
]]
