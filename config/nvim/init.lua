--- [[ Lazy plugin manager ]]
-- https://github.com/folke/lazy.vm
-- See ':Lazy'
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("options")
require("keymaps")
require("lazy").setup("plugins", { rocks = { enabled = false } })

-- LSP config
require("mason").setup()
vim.lsp.enable({
	"lua_ls",
	"ruff",
})
