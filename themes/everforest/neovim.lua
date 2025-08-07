return {
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000,
		config = function()
			require("everforest").setup({
				transparent_background = true,
			})
			vim.cmd.colorscheme("everforest")
		end,
	}
}
