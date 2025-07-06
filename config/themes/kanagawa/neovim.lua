return {
	{
		"erebelot/kanagawa.nvim",
		lazy = false,
		name = "kanagawa",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				transparent_background = true,
			})
			vim.cmd.colorscheme("kanagawa")
		end,
	},
}
