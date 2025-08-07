return {
    -- LuaLS configuration for vim
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    -- Lsp notifications
    {
        "j-hui/fidget.nvim",
        event = "BufReadPre",
        opts = {},
    },
    -- Lsp installer and loader
    {
        "williamboman/mason.nvim",
        event = "BufReadPre",
        config = true,
    },
    -- Token Illuminate
    { "RRethy/vim-illuminate" },
}
