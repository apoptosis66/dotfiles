-- Treesitter: Highlight, edit, and navigate code
-- https://github.com/nvim-treesitter
-- See `:help nvim-treesitter`
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"css",
				"diff",
				"html",
				"java",
				"javascript",
				"jinja",
				"json",
				"kotlin",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"python",
				"sql",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true, -- Autoinstall languages that are not installed
			ignore_install = { "csv" }, --Using Rainbow CSV instead
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = {
				enable = true,
				disable = { "ruby" },
			},
		},
	},
}
