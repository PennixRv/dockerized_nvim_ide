return {
    { --
        "m-demare/hlargs.nvim",
        opts = {},
        event = "User AstroFile"
    }, --
    {
        {
            "machakann/vim-sandwich",
            keys = {
                {"sa", desc = "Add surrounding", mode = {"n", "v"}},
                {"sd", desc = "Delete surrounding"},
                {"sr", desc = "Replace surrounding"}
            }
        }
    }
}
