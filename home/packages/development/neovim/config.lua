if vim.g.neovide then
	vim.g.neovide_cursor_trail_length = 0.05
	vim.g.neovide_cursor_animation_length = 0.05
	vim.g.neovide_cursor_vfx_mode = "pixiedust"
	vim.g.neovide_transparency = 0.95
	vim.o.guifont = "FiraCode Nerd Font Mono:h11"
	vim.g.neovide_padding_top = 12
	vim.g.neovide_padding_bottom = 12
	vim.g.neovide_padding_right = 12
	vim.g.neovide_padding_left = 12
end

vim.opt.timeoutlen = 250
vim.opt.termguicolors = true
vim.opt.fillchars = { eob = " " }
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.o.undofile = true

-- require("everforest").load()

-- require("everforest").setup({
--   background = "hard",
-- })

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		require("nvim-tree.api").tree.open()
	end,
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
	pattern = 'NvimTree*',
	callback = function()
		local api = require('nvim-tree.api')
		local view = require('nvim-tree.view')

		if not view.is_visible() then
			api.tree.open()
		end
	end,
})
