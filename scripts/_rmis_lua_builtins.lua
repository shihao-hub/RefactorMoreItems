local pb = require("_rmis_python_builtins")
local lb = pb

function lb.keys(t)
    local res = {}
    for k, _ in pairs(t) do
        table.insert(res, k)
    end
    return res
end

function lb.values(t)
    local res = {}
    for _, v in pairs(t) do
        table.insert(res, v)
    end
    return res
end

function lb.contain(t, val)
    for _, v in pairs(t) do
        if val == v then
            return true
        end
    end
    return false
end


if debug.getinfo(3) == nil then
    print(lb.any({ 1, nil, 3 }))
    print(lb.all({ 1, 3, 3, nil }))


end

return lb
