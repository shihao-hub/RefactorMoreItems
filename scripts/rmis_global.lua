local g = {}

function g.map(fn, iter)
    local res = {}
    local n = table.maxn(iter)
    for i = 1, n do
        table.insert(res, fn(iter[i]))
    end
    return res
end

return g