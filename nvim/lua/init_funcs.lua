local M = {}

function M.normalize_path()
    local seen = {}
    local parts = {}

    for _, entry in ipairs(vim.split(vim.env.PATH or "", ":", { plain = true, trimempty = true })) do
        if not entry:match("^%d+$") and not seen[entry] then
            seen[entry] = true
            table.insert(parts, entry)
        end
    end

    for _, entry in ipairs({ "/opt/homebrew/bin", "/opt/homebrew/sbin", "/usr/local/bin", "/usr/local/sbin" }) do
        if vim.uv.fs_stat(entry) and not seen[entry] then
            table.insert(parts, 1, entry)
            seen[entry] = true
        end
    end

    vim.env.PATH = table.concat(parts, ":")
end

return M
