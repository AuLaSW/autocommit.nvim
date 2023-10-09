-- A plugin for creating autocommits while you are working on a pojrect

---@enum Actions
local ACTIONS = {
    SAVE = 0,
    INTERVAL = 1,
}

---Main return table for autocommit.nvim
---@type table
local M = {
    ---The program managing git.
    ---@type string
    handler = 'fugitive',
    ---@type table
    commit = {
        ---When to commit.
        ---@type Actions
        when = ACTIONS.SAVE,
        ---How frequently to commit in seconds when committing on an interval.
        ---@type integer?
        freq = nil,
        ---@type fun()
        ---@return string
        header = function ()
            return os.date('[Autocommit] - %c')
        end,
        body = function ()
            return 'This was an automatic commit generated by autocommit.nvim.'
        end,
    },
}

M.create_commit = function ()
    local dir = vim.cmd([[
    let dir = FugitiveGitDir()
    let _ = FugitiveExecute(["add", "."], dir)
    let _ = FugitiveExecute(["commit", "-m", "test"], dir )
    ]])
end

M.setup = function (opts)
    -- recursively copy options from opts into M.opts
    M.opts = vim.tbl_deep_extend(
        'force',
        M.opts,
        opts
    )
end

M.create_commit()

return M
