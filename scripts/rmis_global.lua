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

--- 合并列表，默认会剔除列表中的空值
function g.merge(...)
    local args = { ... }
    local res = {}
    for i in lb.range(1, select("#", ...) + 1) do
        for j in lb.range(1, table.maxn(args[i]) + 1) do
            -- 注意，args[i][j] == nil 时，不会插入！
            table.insert(res, args[i][j])
        end
    end
    return res
end

function g.lt(a, b)
    lb.assert(type(a) == type(b), lb.f("二者类型不一致无法比较({{a}}, {{b}})", { a = type(a), b = type(b) }), 2)
    return a < b
end

function g.eq(a, b)
    lb.assert(type(a) == type(b), lb.f("二者类型不一致无法比较({{a}}, {{b}})", { a = type(a), b = type(b) }), 2)
    return a == b
end

--- 左闭右开才是合理的
function g.right_open(right)
    return right + 1
end

---@param s string
---@param prn Reference
function g.evaluate(s, prn)
    local Stack = require("rmis_class_stack") -- 避免循环引用
    local stack_operand, stack_operator = Stack(), Stack()

end

--function g.ro(right)
--    return g.right_open(right)
--end

--- 2024-07-12：Python 的鸭子类型非常适合 Lua 呀，好舒服，Python 果然太棒了
---@param iterable Vector|List
function g.iter(iterable)
    if not iterable.__iter__ then
        error(lb.f("`{{iterable}}` 没有实现 __iter__ 方法，不可迭代", { iterable = iterable:get_class() }), 2)
    end
    local generator = iterable:__iter__()
    return function()
        return generator()
    end
end

if debug.getinfo(3) == nil then
    --for i in b.range(10, 0, -1) do
    --    print(i)
    --end

    for k, v in g.pairs_by_keys({ b = 2, c = 3, a = 1, ba = 21 }) do
        print(k, v)
    end
    --print(g.lt(1, "2"))
    print(g.list_tostring(g.merge({ 1, nil, 2, nil, 3, 44, }, { 4, nil, 5, nil, 6 })))
end

return g
