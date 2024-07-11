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

--- 此处比 lua 的 assert 多了一个 level 参数
---@overload fun(v:boolean)
---@overload fun(v:boolean,level:number)
---@param v boolean
---@param message string
---@param level number
function lb.assert(v, message, level)
    -- 注意，此处重载了三次函数，与其考虑 if else 的情况，不如直接三个分支，哪怕有重复代码...
    if type(message) == "number" and not level then
        level = message + 1
        message = "assertion failed!"
    else
        message = message or "assertion failed!"
        level = level and level + 1 or 2
    end
    if not v then
        error(message, level)
    end
end

if debug.getinfo(3) == nil then
    print(lb.any({ 1, nil, 3 }))
    print(lb.all({ 1, 3, 3, nil }))
    lb.assert(false, 1)

end

return lb
