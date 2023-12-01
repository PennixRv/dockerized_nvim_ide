return {
    -- {
    --     "smjonas/inc-rename.nvim",
    --     opts = {},
    --     keys = {
    --         {
    --             "<leader>lr",
    --             function()
    --                 require "inc_rename"
    --                 return ":IncRename " .. vim.fn.expand "<cword>"
    --             end,
    --             expr = true,
    --             desc = "IncRename"
    --         }
    --     }
    -- },
    {
        "henry-hsieh/riscv-asm-vim",
        event = "VeryLazy",
        opts = {},
        config = function() end
    }, {
        "aznhe21/actions-preview.nvim",
        config = function()
            vim.keymap.set({"v", "n"}, "gf",
                           require("actions-preview").code_actions)
        end
    }, { --
        {'kosayoda/nvim-lightbulb', config = true}
    }, { --
        {'gfanto/fzf-lsp.nvim', config = true}
    }, { --
        {
            "ray-x/lsp_signature.nvim",
            event = "VeryLazy",
            opts = {},
            config = function(_, opts)
                require'lsp_signature'.setup(opts)
            end
        }
    }, {
        {
            'rmagatti/goto-preview',
            config = function() require('goto-preview').setup {} end
        }
    }
}
