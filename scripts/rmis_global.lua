local lb = require("_rmis_lua_builtins")
local g = lb

function g.pairs_by_keys(t, cmp)
    local keys = lb.keys(t)
    table.sort(keys, cmp)
    local i = 0
    return function()
        i = i + 1
        return keys[i], t[keys[i]]
    end
end

function g.print_and_flush(...)
    print(...)
    io.flush()
end

if debug.getinfo(3) == nil then
    --for i in b.range(10, 0, -1) do
    --    print(i)
    --end

    for k, v in g.pairs_by_keys({ b = 2, c = 3, a = 1, ba = 21 }) do
        print(k, v)
    end
end

return g
