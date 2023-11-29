local prefix = "<leader>a"
local maps = {n = {}}
local icon = vim.g.icons_enabled and "󰷉 " or ""
maps.n[prefix] = {desc = icon .. "Annotation"}
require("astronvim.utils").set_mappings(maps)
return {
    { --------------------
        "LudoPinelli/comment-box.nvim",
        event = "User AstroFile",
        opts = {}
    }, -----------------------------------------------
    {
        "danymat/neogen",
        cmd = "Neogen",
        opts = {
            snippet_engine = "luasnip",
            languages = {
                lua = {template = {annotation_convention = "ldoc"}},
                typescript = {template = {annotation_convention = "tsdoc"}},
                typescriptreact = {template = {annotation_convention = "tsdoc"}}
            }
        },
        keys = {
            {
                prefix .. "<cr>",
                function()
                    require("neogen").generate {type = "current"}
                end,
                desc = "Current"
            }, {
                prefix .. "c",
                function()
                    require("neogen").generate {type = "class"}
                end,
                desc = "Class"
            }, {
                prefix .. "f",
                function()
                    require("neogen").generate {type = "func"}
                end,
                desc = "Function"
            }, {
                prefix .. "t",
                function()
                    require("neogen").generate {type = "type"}
                end,
                desc = "Type"
            }, {
                prefix .. "F",
                function()
                    require("neogen").generate {type = "file"}
                end,
                desc = "File"
            }
        }
    }, ---------------
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {"RRethy/nvim-treesitter-endwise"},
        opts = {endwise = {enable = true}}
    }, ---------------------
    {
        {
            "HiPhish/rainbow-delimiters.nvim",
            dependencies = "nvim-treesitter/nvim-treesitter",
            event = "User AstroFile",
            config = function(_, opts)
                require "rainbow-delimiters.setup"(opts)
            end
        }
    }, -----------------------
    {
        {"windwp/nvim-autopairs", enabled = false}, {
            "altermo/ultimate-autopair.nvim",
            event = "InsertEnter",
            opts = {
                -- disable autopair in the command line: https://github.com/altermo/ultimate-autopair.nvim/issues/8
                cmap = false,
                extensions = {
                    rules = {
                        rules = {
                            {
                                "call", function(o)
                                    -- disable in comments including markdown style
                                    local status, node =
                                        pcall(vim.treesitter.get_node,
                                              {pos = {o.linenr - 1, o.col - 2}})
                                    return
                                        o.incmd or o.col == 1 or not status or
                                            not node or node:type() ~= "comment" and
                                            node:type() ~= "html_block"
                                end
                            }
                        }
                    },
                    -- get fly mode working on strings: https://github.com/altermo/ultimate-autopair.nvim/issues/33
                    fly = {nofilter = true}
                },
                config_internal_pairs = {
                    {'"', '"', fly = true}, {"'", "'", fly = true}
                }
            },
            keys = {
                {
                    "<leader>ua",
                    function()
                        local notify = require("astronvim.utils").notify
                        local function bool2str(bool)
                            return bool and "on" or "off"
                        end
                        local ok, ultimate_autopair = pcall(require,
                                                            "ultimate-autopair")
                        if ok then
                            ultimate_autopair.toggle()
                            vim.g.ultimate_autopair_enabled = require(
                                                                  "ultimate-autopair.core").disable
                            notify(string.format("ultimate-autopair %s",
                                                 bool2str(
                                                     not vim.g
                                                         .ultimate_autopair_enabled)))
                        else
                            notify "ultimate-autopair not available"
                        end
                    end,
                    desc = "Toggle ultimate-autopair"
                }
            }
        }
    }, {
        "nvim-telescope/telescope.nvim",
        dependencies = {"debugloop/telescope-undo.nvim"},
        keys = {{"<leader>fu", "<cmd>Telescope undo<CR>", desc = "Find undos"}},
        opts = function() require("telescope").load_extension "undo" end
    }, -----------------
    { ---
        "johmsalas/text-case.nvim",
        event = "User AstroFile",
        opts = {}
    }, --------
    { ------
        { ---
            "folke/todo-comments.nvim",
            opts = {},
            event = "User AstroFile"
        }
    }, --
    { -----
        "matze/vim-move",
        event = "BufEnter"
    }

}
