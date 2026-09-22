local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local s = ls.snippet
local i = ls.insert_node

return {
    s(
        { trig = "fn", name = "Lua function" },
        fmt(
            [[
function {}({})
    {}
end
]],
            {
                i(1, "name"),
                i(2, "arguments"),
                i(0),
            }
        )
    ),
}
