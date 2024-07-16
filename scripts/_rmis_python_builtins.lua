local super = require("_rmis_base_builtins")
local this = super

--- Return True if bool(x) is True for all values x in the iterable.
--- If the iterable is empty, return True.
---@param iterable table<any>
---@return boolean
function this.all(iterable)
    for i = 1, table.maxn(iterable) do
        if not iterable[i] then
            return false
        end
    end
    return true
end

--- Return True if bool(x) is True for any x in the iterable.
--- If the iterable is empty, return False.
---@param iterable table<any>
---@return boolean
function this.any(iterable)
    for i = 1, table.maxn(iterable) do
        if iterable[i] then
            return true
        end
    end
    return false
end

--- Make an iterator that computes the function using arguments from
--- each of the iterables.  Stops when the shortest iterable is exhausted.
---@param fn function
---@param iterable table<any>
---@return table<any>
function this.map(fn, iterable)
    local res = {}
    local n = iterable.n or table.maxn(iterable)
    for i = 1, n do
        table.insert(res, fn(iterable[i]))
    end
    return res
end

--- this filter
function this.filter(fn, iter)
    -- If function is None, return the items that are true.
    fn = fn or function(v)
        return v
    end
    local res = {}
    local n = table.maxn(iter)
    for i = 1, n do
        if fn(iter[i]) then
            table.insert(res, iter[i])
        end
    end
    return res
end

--- this range
--- 但有些区别，Python 是 [)，由于 Lua 从 1 开始，所以 Lua 用 [] 比较好？
--- 还是需要考虑考虑的。目前和 this 统一吧。（这里我突然意识到，为什么说 Lua 从 1 开始反程序员了）
function this.range(start, stop, step)
    if start and not stop then
        stop = start
        start = 1
    end
    step = step or 1
    return function()
        if step > 0 and start >= stop or step < 0 and start <= stop then
            return nil
        end
        local res = start
        start = start + step
        return res
    end
end

function this.sorted(iterable, key, reverse)
    super.not_implemented_error()
end

--- 试图模仿 this 的 f
function this.f(formatstring, data)
    return (string.gsub(formatstring, "{{ *([A-Za-z0-9_]*) *}}", function(v)
        -- 捕获到的内容是这个 v，需要注意到是，没匹配到不会进入这个函数。所以要注意...
        if not data[v] then
            error("data 中不存在 " .. v .. " 这个键或者键值为空", 4)
        end
        return string.format("%s", tostring(data[v]))
    end))
end

if debug.getinfo(3) == nil then
    print(this.any({ 1, nil, 3 }))
    print(this.all({ 1, 3, 3, nil }))
    print(super.list_tostring(this.filter(function(x)
        return x > 10
    end, { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 })))

end

return this
