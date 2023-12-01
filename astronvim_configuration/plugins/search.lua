return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            {
                "s",
                mode = {"n", "x", "o"},
                function() require("flash").jump() end,
                desc = "Flash"
            }, {
                "S",
                mode = {"n", "o", "x"},
                function() require("flash").treesitter() end,
                desc = "Flash Treesitter"
            }, {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc = "Remote Flash"
            }, {
                "R",
                mode = {"o", "x"},
                function() require("flash").treesitter_search() end,
                desc = "Treesitter Search"
            }, {
                "<c-s>",
                mode = {"c"},
                function() require("flash").toggle() end,
                desc = "Toggle Flash Search"
            }
        }
    }, {
        "ray-x/sad.nvim",
        dependencies = {"ray-x/guihua.lua", build = "cd lua/fzy && make"},
        opts = {},
        event = "User AstroFile",
        cmd = {"Sad"}
    }, {
        "kevinhwang91/nvim-hlslens",
        opts = {},
        event = "BufRead",
        init = function()
            vim.on_key(nil, vim.api.nvim_get_namespaces()["auto_hlsearch"])
        end
    }, { --
        {'AckslD/muren.nvim', config = true}
    }, { --
        {'nvim-pack/nvim-spectre', config = true}
    }
}
