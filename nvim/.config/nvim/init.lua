-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.colors_name = "catppuccin"

-- Ensure termguicolors is enabled if not already
vim.opt.termguicolors = true

require("nvim-highlight-colors").setup({})
