local utils = require "astronvim.utils"
local prefix = "<leader>g"
local icon = vim.g.icons_enabled and "󰰔 " or ""
utils.set_mappings {n = {[prefix] = {desc = icon .. "Neogit"}}}

local fold_signs = {utils.get_icon "FoldClosed", utils.get_icon "FoldOpened"}
return {
    {
        {
            "sindrets/diffview.nvim",
            event = "User AstroGitFile",
            cmd = {"DiffviewOpen"}
        }, {
            "NeogitOrg/neogit",
            optional = true,
            opts = {integrations = {diffview = true}}
        }
    }, --
    { --
        "f-person/git-blame.nvim",
        event = "User AstroGitFile"
    }, {
        {
            "NeogitOrg/neogit",
            dependencies = {{"nvim-lua/plenary.nvim"}},
            event = "User AstroGitFile",
            opts = function(_, opts)
                local disable_builtin_notifications =
                    utils.is_available "nvim-notify" or
                        utils.is_available "noice.nvim"

                return utils.extend_tbl(opts, {
                    disable_builtin_notifications = disable_builtin_notifications,
                    telescope_sorter = function()
                        if utils.is_available "telescope-fzf-native.nvim" then
                            return require("telescope").extensions.fzf
                                       .native_fzf_sorter()
                        end
                    end,
                    integrations = {
                        telescope = utils.is_available "telescope.nvim"
                    },
                    signs = {section = fold_signs, item = fold_signs}
                })
            end,
            keys = {
                {
                    prefix .. "nt",
                    "<cmd>Neogit<CR>",
                    desc = "Open Neogit Tab Page"
                },
                {
                    prefix .. "nc",
                    "<cmd>Neogit commit<CR>",
                    desc = "Open Neogit Commit Page"
                },
                {
                    prefix .. "nd",
                    ":Neogit cwd=",
                    desc = "Open Neogit Override CWD"
                },
                {
                    prefix .. "nk",
                    ":Neogit kind=",
                    desc = "Open Neogit Override Kind"
                }
            }
        },
        {
            "catppuccin/nvim",
            optional = true,
            opts = {integrations = {neogit = true}}
        }
    }, {
        'akinsho/git-conflict.nvim',
        version = "*",
        config = true,
        opts = {
            default_mappings = true, -- disable buffer local mapping created by this plugin
            default_commands = true, -- disable commands created by this plugin
            disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
            highlights = { -- They must have background color, otherwise the default color will be used
                incoming = 'DiffAdd',
                current = 'DiffText'
            }
        }
    }
}
