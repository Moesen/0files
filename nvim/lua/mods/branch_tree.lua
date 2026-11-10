-- Neo-tree "branch diff" mode: show only files changed since the current
-- branch forked from its parent branch. Toggle is per session (starts off).

local M = {}

local enabled = false

local function git(args)
    local out = vim.fn.systemlist(vim.list_extend({ "git" }, args))
    if vim.v.shell_error ~= 0 then
        return nil
    end
    return out
end

local function branch_exists(name)
    return git({ "rev-parse", "--verify", "--quiet", "refs/heads/" .. name }) ~= nil
end

-- 1) Reflog: oldest "checkout: moving from X to <current>" where X is a branch.
local function parent_from_reflog(current)
    local lines = git({ "reflog", "show", "HEAD", "--format=%gs" }) or {}
    local parent
    for _, line in ipairs(lines) do -- newest first; keep overwriting to get oldest
        local from = line:match("^checkout: moving from (.+) to " .. vim.pesc(current) .. "$")
        if from and from ~= current and branch_exists(from) then
            parent = from
        end
    end
    return parent
end

-- 2) Fallback: local branch whose merge-base with HEAD is closest to HEAD.
local function parent_from_merge_base(current)
    local head = (git({ "rev-parse", "HEAD" }) or {})[1]
    local best, best_count
    for _, name in ipairs(git({ "for-each-ref", "--format=%(refname:short)", "refs/heads" }) or {}) do
        if name ~= current then
            local mb = (git({ "merge-base", "HEAD", name }) or {})[1]
            -- Skip branches built on top of HEAD (children of this branch).
            if mb and mb ~= head then
                local count = tonumber((git({ "rev-list", "--count", mb .. "..HEAD" }) or {})[1])
                if count and (not best_count or count < best_count) then
                    best, best_count = name, count
                end
            end
        end
    end
    return best
end

-- Returns merge-base sha and the parent branch name, or nil.
function M.base()
    local current = (git({ "branch", "--show-current" }) or {})[1]
    if not current or current == "" then
        return nil
    end
    local parent = parent_from_reflog(current) or parent_from_merge_base(current)
    if not parent then
        return nil
    end
    local sha = (git({ "merge-base", "HEAD", parent }) or {})[1]
    if not sha then
        return nil
    end
    return sha, parent
end

function M.is_enabled()
    return enabled
end

-- Neo-tree command opts for the current mode (source + git_base).
function M.source_opts()
    if M.is_enabled() then
        local sha, parent = M.base()
        if sha then
            M.parent = parent
            return { source = "git_status", git_base = sha }, parent
        end
    end
    M.parent = nil
    return { source = "filesystem" }
end

-- Replacement for neo-tree's git_status "name" component: titles the root
-- "CHANGES since <parent>" while branch diff mode is active.
function M.name_component(config, node, state)
    local result = require("neo-tree.sources.git_status.components").name(config, node, state)
    if M.parent and node.type == "directory" and node:get_depth() == 1 then
        local suffix = node:has_children() and "" or " (none)"
        result.text = "CHANGES since " .. M.parent .. suffix
    end
    return result
end

function M.toggle()
    enabled = not enabled

    local opts, parent = M.source_opts()
    require("neo-tree.command").execute(vim.tbl_extend("force", {
        position = "left",
        action = "focus",
    }, opts))

    if not enabled then
        vim.notify("Neo-tree: all files")
    elseif parent then
        vim.notify("Neo-tree: changes vs " .. parent)
    else
        vim.notify("Neo-tree: branch diff on, but no parent branch found", vim.log.levels.WARN)
    end
end

return M
