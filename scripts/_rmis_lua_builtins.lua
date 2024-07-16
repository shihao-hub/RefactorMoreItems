local super = require("_rmis_python_builtins")
local this = super -- 有 Lua 的风格的函数放在这个文件中，虽然目前没感觉到 Lua 风格代码是啥


--- 合并列表，默认会剔除列表中的空值
function this.merge(...)
    local args = { ... }
    local res = {}
    for i in super.range(1, select("#", ...) + 1) do
        for j in super.range(1, table.maxn(args[i]) + 1) do
            -- 注意，args[i][j] == nil 时，不会插入！
            table.insert(res, args[i][j])
        end
    end
    return res
end

--- 并集
function this.union(v1, v2)
    local function set_add(set, t)
        for i in super.range(super.right_open(table.maxn(t))) do
            if t[i] then
                set[t[i]] = true
            end
        end
    end

    local set = {}
    set_add(set, v1)
    set_add(set, v2)
    return super.keys(set)
end

--- 交集
function this.intersection(v1, v2)
    local map = {}
    for i in super.range(super.right_open(table.maxn(v1))) do
        if v1[i] then
            map[v1[i]] = 1
        end
    end
    for i in super.range(super.right_open(table.maxn(v2))) do
        if v2[i] then
            map[v2[i]] = map[v2[i]] and map[v2[i]] + 1 or 1
        end
    end
    return super.keys(map, function(k)
        return map[k] > 1
    end)
end

--- 差集：以 v1 为目标数据，去除 v1 和 v2 的共同数据
function this.difference(v1, v2)
    local map = {}
    for i in super.range(super.right_open(table.maxn(v1))) do
        if v1[i] then
            map[v1[i]] = 1
        end
    end
    for i in super.range(super.right_open(table.maxn(v2))) do
        if v2[i] and map[v2[i]] then
            map[v2[i]] = map[v2[i]] - 1
        end
    end
    return super.keys(map, function(k)
        return map[k] > 0
    end)
end

if debug.getinfo(3) == nil then
    --print(this.any({ 1, nil, 3 }))
    --print(this.all({ 1, 3, 3, nil }))
    ----this.assert(false, 1)
    --print({ [nil] = 1 })
    print(this.list_tostring(this.union({ 1, 2 }, { 1, 2, 3, 4 })))
    print(this.list_tostring(this.intersection({ 1, 2, 4 }, { 1, 2, 3, 4 })))
    print(this.list_tostring(this.difference({ 1, 2, 4, 5 }, { 1, 2, 3, 4 })))
end

return this
