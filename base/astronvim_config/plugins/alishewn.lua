return {
    {"onsails/lspkind.nvim", event = "VeryLazy", opts = {}},
    {"gfanto/fzf-lsp.nvim", event = "VeryLazy", opts = {}},
    {"simrat39/symbols-outline.nvim", event = "VeryLazy", opts = {}},
    {"rmagatti/goto-preview", event = "VeryLazy", opts = {}}, --
    {
        "roobert/search-replace.nvim",
        config = function()
            require("search-replace").setup({
                -- optionally override defaults
                default_replace_single_buffer_options = "gcI",
                default_replace_multi_buffer_options = "egcI"
            })
        end
    }, --
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- configuration here, or leave empty to use defaults
            })
        end
    }, --
    {"AckslD/muren.nvim", config = true}, --
    {"danielpieper/telescope-tmuxinator.nvim", opts = {}}, --
    {
        "sudormrfbin/cheatsheet.nvim",
        opts = {},
        dependencies = {
            "nvim-telescope/telescope.nvim", "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim"
        }
    }, --
    {
        "andrewferrier/debugprint.nvim",
        opts = {...},
        -- Dependency only needed for NeoVim 0.8
        dependencies = {"nvim-treesitter/nvim-treesitter"},
        -- Remove the following line to use development versions,
        -- not just the formal releases
        version = "*"
    },
    {
        "aserowy/tmux.nvim",
        config = function() return require("tmux").setup() end
    }, --
    {
        {
            'axkirillov/hbac.nvim',
            dependencies = {
                -- these are optional, add them, if you want the telescope module
                'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim',
                'nvim-tree/nvim-web-devicons'
            },
            config = function() require("hbac").setup() end
        }
    }, ---
    {
        'tomasky/bookmarks.nvim',
        event = "VimEnter",
        config = function() require('bookmarks').setup() end
    }, {
        {
            'akinsho/git-conflict.nvim',
            version = "*",
            config = true,
            opts = {default_mappings = false}
        }
    }, {
        { ---
            "m-demare/hlargs.nvim",
            opts = {},
            event = "User AstroFile"
        }
    }, {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {"andymass/vim-matchup"},
        init = function()
            vim.g.matchup_matchparen_offscreen = {
                method = "popup",
                fullwidth = 1,
                highlight = "Normal",
                syntax_hl = 1
            }
            vim.g.matchup_matchparen_deferred = 1
        end,
        opts = {matchup = {enable = true}}
    }, {
        "Pocco81/HighStr.nvim",
        opts = {
            verbosity = 0,
            saving_path = "/tmp/highstr/",
            highlight_colors = {
                -- color_id = {"bg_hex_code",<"fg_hex_code"/"smart">}
                color_0 = {"#0c0d0e", "smart"}, -- Cosmic charcoal
                color_1 = {"#e5c07b", "smart"}, -- Pastel yellow
                color_2 = {"#7FFFD4", "smart"}, -- Aqua menthe
                color_3 = {"#8A2BE2", "smart"}, -- Proton purple
                color_4 = {"#FF4500", "smart"}, -- Orange red
                color_5 = {"#008000", "smart"}, -- Office green
                color_6 = {"#0000FF", "smart"}, -- Just blue
                color_7 = {"#FFC0CB", "smart"}, -- Blush pink
                color_8 = {"#FFF9E3", "smart"}, -- Cosmic latte
                color_9 = {"#7d5c34", "smart"} -- Fallow brown
            }
        }
    }, {"matze/vim-move", event = "BufEnter"},
    {"jabirali/vim-tmux-yank", event = "User AstroFile"},
    {"willothy/flatten.nvim", opts = {}, lazy = false, priority = 1001},
    {"SmiteshP/nvim-navic", dependencies = "neovim/nvim-lspconfig"},
    {'kosayoda/nvim-lightbulb', opts = {{'kosayoda/nvim-lightbulb'}}}, {
        "onsails/lspkind.nvim",
        opts = {
            mode = 'symbol_text',
            preset = 'codicons',
            symbol_map = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = ""
            }
        }
    }, {
        'ojroques/nvim-lspfuzzy',
        dependencies = {
            {'junegunn/fzf'}, {'junegunn/fzf.vim'} -- to enable preview (optional)
        }
    }, {"gfanto/fzf-lsp.nvim", event = "VeryLazy", opts = {}}, {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require'lsp_signature'.setup(opts) end
    }, {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "SmiteshP/nvim-navbuddy",
                dependencies = {"SmiteshP/nvim-navic", "MunifTanjim/nui.nvim"},
                opts = {lsp = {auto_attach = true}}
            }
        }
    }, {"simrat39/symbols-outline.nvim", event = "VeryLazy", opts = {}}, {
        'tomasky/bookmarks.nvim',
        event = "VimEnter",
        config = function() require('bookmarks').setup() end,
        opts = {
            save_file = vim.fn.expand "$HOME/.bookmarks", -- bookmarks save file path
            keywords = {
                ["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
                ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
                ["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
                ["@n"] = " " -- mark annotation startswith @n ,signs this icon as `Note`
            },
            on_attach = function(bufnr)
                local bm = require "bookmarks"
                local map = vim.keymap.set
                map("n", "mm", bm.bookmark_toggle) -- add or remove bookmark at current line
                map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
                map("n", "mc", bm.bookmark_clean) -- clean all marks in local buffer
                map("n", "mn", bm.bookmark_next) -- jump to next mark in local buffer
                map("n", "mp", bm.bookmark_prev) -- jump to previous mark in local buffer
                map("n", "ml", bm.bookmark_list) -- show marked file list in quickfix window
            end
        }
    }
}
