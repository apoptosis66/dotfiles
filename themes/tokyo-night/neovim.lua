return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		name = "tokyonight",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				transparent_background = true,
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
