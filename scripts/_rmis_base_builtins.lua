local this = {}

--- 将序列转为字符串
---@param list table<any>
---@return string
function this.list_tostring(list, left, right)
    left = left or 1
    right = right or table.maxn(list)
    local res = {}
    table.insert(res, "[")
    for i = left, right do
        table.insert(res, (string.format(type(list[i]) == "string" and "%q" or "%s", tostring(list[i]))) .. (i ~= right and ", " or ""))
    end
    table.insert(res, "]")
    return table.concat(res)
end

--- 此处比 lua 的 assert 多了一个 level 参数
---@overload fun(v:boolean)
---@overload fun(v:boolean,level:number)
---@param v boolean
---@param message string
---@param level number
function this.assert(v, message, level)
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

function this.print_and_flush(...)
    print(...)
    io.flush()
end

function this.debug_mode()
    return debug.getinfo(4) == nil
end

--- 左闭右开才是合理的
function this.right_open(right)
    return right + 1
end

function this.ro(right)
    return this.right_open(right)
end

function this.keys(t, filter)
    filter = filter or function()
        return true
    end
    local res = {}
    for k, _ in pairs(t) do
        if filter(k) then
            table.insert(res, k)
        end
    end
    return res
end

function this.values(t, filter)
    filter = filter or function()
        return true
    end
    local res = {}
    for _, v in pairs(t) do
        if filter(v) then
            table.insert(res, v)
        end
    end
    return res
end

function this.contain(t, val)
    for _, v in pairs(t) do
        if val == v then
            return true
        end
    end
    return false
end

--- 暂未实现的函数直接报错
function this.not_implemented_error(msg)
    error("未实现错误" .. (msg and "：" .. msg or ""), 3)
end

function this.subclass_responsibility_error(msg)
    error("子类未履行职责错误" .. (msg and "：" .. msg or ""), 3)
end

function this.untested_error(msg)
    local info = debug.getinfo(2)
    msg = msg or string.format("%s:%s 函数未经过测试，不允许调用", info.short_src, info.name)
    error("未测试错误：" .. msg, 3)
end

if debug.getinfo(3) == nil then
    -- 此处验证了一下 table.maxn 确实可以找完整
    local t = { 1, 2, 3, nil, 4, 5, nil, nil, nil, nil, 100 }
    print(this.list_tostring(t))
    t[20] = 200
    print(this.list_tostring(t))
end

return this
