return {
    options = {
        g = {
            diagnostics_mode = 3,
            inlay_hints_enabled = false,
            riscv_asm_all_enable = 1
            -- autoformat_enabled = false
        },
        b = {inlay_hints_enabled = false},
        opt = {relativenumber = false, foldcolumn = "0"}
    },
    icons = {
        VimIcon = "",
        ScrollText = "",
        GitBranch = "",
        GitAdd = "",
        GitChange = "",
        GitDelete = ""
    },
    lazy = {
        git = {
            timeout = 30
            -- url_format = 'https://hub.gitmirror.com/https://github.com/%s.git'
        }
    }
}
