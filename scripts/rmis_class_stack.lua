local g = require("rmis_global")

local Stack = require("_rmis_class_stack_local")

Stack.static.__apis__ = {
    "size",
    "empty",
    "push",
    "pop",
    "top",
}

--[[下面这段代码将 super:insert(e) -> self:insert(e) 将会出现问题：self:size() 永远返回 0！
    因为 self:insert 会塞到 self 里，而 self:size() 调用了 super:size()，super 里面的 self._size = 0...
    所以，除非 override 的函数，不然调用的时候，必须用 super 调用！！！而且构造函数必须重写？
    但是我发现，除了父类的构造函数，只要不要在其他地方调用 super 似乎就可以了...

    function Stack:initialize() super:initialize() end
    function Stack:size() return super:size() end
    function Stack:empty() return super:empty() end
    function Stack:push() super:insert(e) end
    function Stack:pop() return super:remove(self:size()) end
    function Stack:top() return return super:get(self:size()) end
]]

-- Lua 模拟的继承好像有问题呀？用 Java 试验了一下，确实原理不一样，Java 的继承并不会出现这个问题！
-- 2024-07-11:
--      不对吧，super:initialize() 都不能调用吧？调用了直接修改了 class Vector 的内容啊！这怎么可以！
--      测试发现，确实如此啊！这不对吧？怎么可以这样！
--      我去，应该这样调用：super.initialize(self,...)！！！
function Stack:initialize()
    Stack.super.initialize(self)
end

function Stack:size()
    return Stack.super.size(self)
end

function Stack:empty()
    return Stack.super.empty(self)
end

function Stack:push(e)
    self:insert(e)
end

function Stack:pop()
    g.assert(self:empty() == false, "栈为空", 2)
    return self:remove(self:size())
end

function Stack:top()
    return self:get(self:size())
end

function Stack:__tostring()
    local res = {}
    table.insert(res, "] ")
    for i in g.range(self:size(), 0, -1) do
        table.insert(res, g.f("{{data}}" .. (i == 1 and "" or ", "), { data = self:get(i) }))
    end
    table.insert(res, " ]")
    return table.concat(res)
end

if g.debug_mode() then
    local stack = Stack()
    stack:push(1)
    stack:push(2)
    stack:push(3)
    stack:push(4)
    stack:push(5)
    print(stack)
end

return Stack
