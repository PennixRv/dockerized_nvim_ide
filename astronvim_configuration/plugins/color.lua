return {
    {
        {"NvChad/nvim-colorizer.lua", enabled = false}, {
            "uga-rosa/ccc.nvim",
            event = {"User AstroFile", "InsertEnter"},
            cmd = {
                "CccPick", "CccConvert", "CccHighlighterEnable",
                "CccHighlighterDisable", "CccHighlighterToggle"
            },
            keys = {
                {
                    "<leader>uC",
                    "<cmd>CccHighlighterToggle<cr>",
                    desc = "Toggle colorizer"
                },
                {"<leader>zc", "<cmd>CccConvert<cr>", desc = "Convert color"},
                {"<leader>zp", "<cmd>CccPick<cr>", desc = "Pick Color"}
            },
            opts = {highlighter = {auto_enable = true, lsp = true}},
            config = function(_, opts)
                require("ccc").setup(opts)
                if opts.highlighter and opts.highlighter.auto_enable then
                    vim.cmd.CccHighlighterEnable()
                end
            end
        }
    }, {
        "azabiong/vim-highlighter",
        lazy = false, -- Not Lazy by default
        keys = {
            -- These are basing keymaps to guide new users
            {"f<Enter>", desc = "Highlight"},
            {"f<BS>", desc = "Remove Highlight"},
            {"f<C-L>", desc = "Clear Highlight"},
            {"f<Tab>", desc = "Find Highlight (similar to Telescope grep)"}
            -- They are derivated from the default keymaps, see README.md to github repo for documentation
            -- { "nn", "<cmd>Hi><CR>", desc = "Next Recently Set Highlight" },
            -- { "ng", "<cmd>Hi<<CR>", desc = "Previous Recently Set Highlight" },
            -- { "n[", "<cmd>Hi{<CR>", desc = "Next Nearest Highlight" },
            -- { "n]", "<cmd>Hi}<CR>", desc = "Previous Nearest Highlight" },
        }
    }
}
