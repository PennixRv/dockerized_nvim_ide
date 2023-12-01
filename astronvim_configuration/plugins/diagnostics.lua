local prefix = "<leader>x"
local maps = {n = {}}
local icon = vim.g.icons_enabled and "󱍼 " or ""
maps.n[prefix] = {desc = icon .. "Trouble"}
require("astronvim.utils").set_mappings(maps)
return {
    {
        {
            "folke/trouble.nvim",
            cmd = {"TroubleToggle", "Trouble"},
            keys = {
                {
                    prefix .. "X",
                    "<cmd>TroubleToggle workspace_diagnostics<cr>",
                    desc = "Workspace Diagnostics (Trouble)"
                }, {
                    prefix .. "x",
                    "<cmd>TroubleToggle document_diagnostics<cr>",
                    desc = "Document Diagnostics (Trouble)"
                }, {
                    prefix .. "l",
                    "<cmd>TroubleToggle loclist<cr>",
                    desc = "Location List (Trouble)"
                }, {
                    prefix .. "q",
                    "<cmd>TroubleToggle quickfix<cr>",
                    desc = "Quickfix List (Trouble)"
                }
            },
            opts = {
                use_diagnostic_signs = true,
                action_keys = {close = {"q", "<esc>"}, cancel = "<c-e>"}
            }
        }, {
            "folke/edgy.nvim",
            optional = true,
            opts = function(_, opts)
                if not opts.bottom then opts.bottom = {} end
                table.insert(opts.bottom, "Trouble")
            end
        }
    },
    --------------------------------------------------------------------------------
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = "LspAttach",
        keys = {
            {
                "<Leader>uD",
                function()
                    vim.diagnostic.config {
                        virtual_text = not require("lsp_lines").toggle()
                    }
                end,
                desc = "Toggle virtual diagnostic lines"
            }
        },
        opts = {},
        config = function(_, opts)
            -- disable diagnostic virtual text
            local lsp_utils = require "astronvim.utils.lsp"
            lsp_utils.diagnostics[3].virtual_text = false
            vim.diagnostic.config(lsp_utils.diagnostics[vim.g.diagnostics_mode])
            require("lsp_lines").setup(opts)
        end
    }
}
