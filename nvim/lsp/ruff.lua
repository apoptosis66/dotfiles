return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
	init_options = {
		settings = {
			-- https://docs.astral.sh/ruff/rules/
			organizeImports = true,
			lint = {
				extendSelect = {
					"A",
					"ARG",
					"B",
					"COM",
					"C4",
					"DOC",
					"FBT",
					"I",
					"ICN",
					"N",
					"PERF",
					"PL",
					"Q",
					"RET",
					"RUF",
					"SIM",
					"SLF",
					"TID",
					"W",
				},
			},
		},
	},
	settings = {},
}
