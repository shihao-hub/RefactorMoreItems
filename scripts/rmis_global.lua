local super = require("_rmis_lua_builtins")
local this = super

function this.pairs_by_keys(t, cmp)
    local keys = super.keys(t)
    table.sort(keys, cmp)
    local i = 0
    return function()
        i = i + 1
        return keys[i], t[keys[i]]
    end
end



function this.lt(a, b)
    super.assert(type(a) == type(b), super.f("二者类型不一致无法比较({{a}}, {{b}})", { a = type(a), b = type(b) }), 2)
    return a < b
end

function this.eq(a, b)
    super.assert(type(a) == type(b), super.f("二者类型不一致无法比较({{a}}, {{b}})", { a = type(a), b = type(b) }), 2)
    return a == b
end


---@param s string
---@param prn Reference
function this.evaluate(s, prn)
    local Stack = require("rmis_class_stack") -- 避免循环引用
    local stack_operand, stack_operator = Stack(), Stack()

end

--function this.ro(right)
--    return this.right_open(right)
--end

--- 2024-07-12：Python 的鸭子类型非常适合 Lua 呀，好舒服，Python 果然太棒了
---@param iterable Vector|List
function this.iter(iterable)
    if not iterable.__iter__ then
        error(super.f("`{{iterable}}` 没有实现 __iter__ 方法，不可迭代", { iterable = iterable:get_class() }), 2)
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

    for k, v in this.pairs_by_keys({ b = 2, c = 3, a = 1, ba = 21 }) do
        print(k, v)
    end
    --print(this.lt(1, "2"))
    print(this.list_tostring(this.merge({ 1, nil, 2, nil, 3, 44, }, { 4, nil, 5, nil, 6 })))
end

return this
