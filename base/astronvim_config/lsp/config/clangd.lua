local function switch_source_header_splitcmd(bufnr, splitcmd)
    bufnr = require("lspconfig").util.validate_bufnr(bufnr)
    local clangd_client = require("lspconfig").util.get_active_client_by_name(
                              bufnr, "clangd")
    local params = {uri = vim.uri_from_bufnr(bufnr)}
    if clangd_client then
        clangd_client.request("textDocument/switchSourceHeader", params,
                              function(err, result)
            if err then error(tostring(err)) end
            if not result then
                vim.notify("Corresponding file can’t be determined",
                           vim.log.levels.ERROR, {title = "LSP Error!"})
                return
            end
            vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
        end)
    else
        vim.notify(
            "Method textDocument/switchSourceHeader is not supported by any active server on this buffer",
            vim.log.levels.ERROR, {title = "LSP Error!"})
    end
end

local nproc = function()
    local procn = tonumber(vim.fn.system('nproc'))
    if procn == nil then
        return 4
    else
        return procn
    end
end

return {
    capabilities = {offsetEncoding = "utf-16"},
    cmd = {
        "clangd", "--header-insertion=iwyu", "--clang-tidy", "-j=" .. nproc(),
        "--header-insertion-decorators", "--all-scopes-completion",
        "--pch-storage=memory", "--background-index",
        "--background-index-priority=low", "--clang-tidy",
        "--completion-style=detailed", "--function-arg-placeholders",
        "--header-insertion=never", "--limit-references=200",
        "--limit-results=200", "--enable-config", "--log=verbose", "--pretty"
    },
    commands = {
        ClangdSwitchSourceHeader = {
            function() switch_source_header_splitcmd(0, "edit") end,
            description = "Open source/header in current buffer"
        },
        ClangdSwitchSourceHeaderVSplit = {
            function() switch_source_header_splitcmd(0, "vsplit") end,
            description = "Open source/header in a new vsplit"
        },
        ClangdSwitchSourceHeaderSplit = {
            function() switch_source_header_splitcmd(0, "split") end,
            description = "Open source/header in a new split"
        }
    }
}
