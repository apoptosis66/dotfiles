return {
	{
		"RedsXDD/neopywal.nvim",
		name = "neopywal",
		lazy = false,
		priority = 1000,
		version = "*",
		config = function()
			require("neopywal").setup({
				colorscheme_file = os.getenv("HOME") .. "/.config/nvim/theme.vim",
			})
			vim.cmd.colorscheme("neopywal")
		end,
	},
}
