return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true,
        default_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = true,
          which_key = true,
          markdown = true,
          notify = true,
          indent_blankline = { enabled = true },
          fzf = true,
          render_markdown = true,
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
