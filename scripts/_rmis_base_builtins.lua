local b = {}

--- 将序列转为字符串
---@param list table<any>
---@return string
function b.list_tostring(list, left, right)
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

--- 暂未实现的函数直接报错
function b.not_implemented_error(msg)
    error("未实现错误" .. (msg and "：" .. msg or ""), 2)
end

function b.subclass_responsibility_error(msg)
    error("子类未履行职责错误" .. (msg and "：" .. msg or ""), 2)
end

function b.untested_error(msg)
    local info = debug.getinfo(2)
    msg = msg or string.format("%s:%s 函数未经过测试，不允许调用", info.short_src, info.name)
    error("未测试错误：" .. msg, 2)
end

if debug.getinfo(3) == nil then
    -- 此处验证了一下 table.maxn 确实可以找完整
    local t = { 1, 2, 3, nil, 4, 5, nil, nil, nil, nil, 100 }
    print(b.list_tostring(t))
    t[20] = 200
    print(b.list_tostring(t))
end

return b
