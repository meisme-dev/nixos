if vim.g.neovide then
  vim.g.neovide_cursor_trail_length = 0.05  
  vim.g.neovide_cursor_animation_length = 0.05  
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.o.guifont = "FiraCode Nerd Font Mono:h11"
end

vim.opt.timeoutlen = 250
vim.opt.termguicolors = true
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

require("everforest").load()

require("everforest").setup({
  background = "hard",
})

vim.api.nvim_create_autocmd({ "VimEnter" }, { 
  callback = function()
    require("nvim-tree.api").tree.open() 
  end,
})
