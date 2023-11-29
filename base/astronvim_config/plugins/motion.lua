return {
    {
        {
            "ggandor/flit.nvim",
            keys = function()
                ---@type LazyKeys[]
                local ret = {}
                for _, key in ipairs {"f", "F", "t", "T"} do
                    ret[#ret + 1] = {key, mode = {"n", "x", "o"}, desc = key}
                end
                return ret
            end,
            opts = {labeled_modes = "nx"},
            dependencies = {
                "ggandor/leap.nvim",
                dependencies = {"tpope/vim-repeat"}
            }
        }
    }, {
        {
            "ggandor/leap.nvim",
            keys = {
                {
                    "s",
                    "<Plug>(leap-forward-to)",
                    mode = {"n", "x", "o"},
                    desc = "Leap forward to"
                }, {
                    "S",
                    "<Plug>(leap-backward-to)",
                    mode = {"n", "x", "o"},
                    desc = "Leap backward to"
                }, {
                    "x",
                    "<Plug>(leap-forward-till)",
                    mode = {"x", "o"},
                    desc = "Leap forward till"
                }, {
                    "X",
                    "<Plug>(leap-backward-till)",
                    mode = {"x", "o"},
                    desc = "Leap backward till"
                }, {
                    "gs",
                    "<Plug>(leap-from-window)",
                    mode = {"n", "x", "o"},
                    desc = "Leap from window"
                }
            },
            opts = {},
            init = function() -- https://github.com/ggandor/leap.nvim/issues/70#issuecomment-1521177534
                vim.api.nvim_create_autocmd("User", {
                    callback = function()
                        vim.cmd.hi("Cursor", "blend=100")
                        vim.opt.guicursor:append{"a:Cursor/lCursor"}
                    end,
                    pattern = "LeapEnter"
                })
                vim.api.nvim_create_autocmd("User", {
                    callback = function()
                        vim.cmd.hi("Cursor", "blend=0")
                        vim.opt.guicursor:remove{"a:Cursor/lCursor"}
                    end,
                    pattern = "LeapLeave"
                })
            end,
            dependencies = {"tpope/vim-repeat"}
        }
    }, {
        "chentoast/marks.nvim",
        event = "User AstroFile",
        opts = {
            excluded_filetypes = {
                "qf", "NvimTree", "toggleterm", "TelescopePrompt", "alpha",
                "netrw", "neo-tree"
            }
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
        {
            {
                "phaazon/hop.nvim",
                opts = {},
                keys = {
                    {
                        "s",
                        function()
                            require("hop").hint_words()
                        end,
                        mode = {"n"},
                        desc = "Hop hint words"
                    }, {
                        "<S-s>",
                        function()
                            require("hop").hint_lines()
                        end,
                        mode = {"n"},
                        desc = "Hop hint lines"
                    }, {
                        "s",
                        function()
                            require("hop").hint_words {extend_visual = true}
                        end,
                        mode = {"v"},
                        desc = "Hop hint words"
                    }, {
                        "<S-s>",
                        function()
                            require("hop").hint_lines {extend_visual = true}
                        end,
                        mode = {"v"},
                        desc = "Hop hint lines"
                    }
                }
            },
            {
                "catppuccin/nvim",
                optional = true,
                opts = {integrations = {hop = true}}
            }
        }
    }
}
