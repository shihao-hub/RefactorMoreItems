local g = require("rmis_global")
local class = require("rmis_middleclass")
local Object = require("rmis_class_object")

---@class LinearList : Object
local LinearList = class("LinearList",Object)

-- 目前，Vector 和 List 会实现这个接口，那么此处的 __apis__ 则是他们的共同部分
LinearList.static.__apis__ = {
    -- ADT 接口
    "size",
    "remove",
    "disordered",
    "sort",
    "find",
    "search",
    "deduplicate",
    "uniquify",
    "traverse",
}

function LinearList:initialize()
    -- FIXME 接口好像实现不了？回头再看看
    for _, v in ipairs(self.static.__apis__) do
        print(g.list_tostring(self))
        if not rawget(self, v) then
            error(g.f("存在抽象函数未实现 ({{func}})", { func = v }))
        end
    end
end

function LinearList:size()
    g.not_implemented_error()
end

--- 删除序号为 r 的元素，返回该元素中原存放的对象
---@param r number
function LinearList:remove(r)
    g.not_implemented_error()
end

function LinearList:disordered()
    g.not_implemented_error()
end

--- 查找等于 e 且秩最大的元素，[lo, hi)
---@overload fun(e:any):boolean
function LinearList:find(e, lo, hi)
    g.not_implemented_error()
end

return LinearList
