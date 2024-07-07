local class = require("rmis_middleclass")
local str = require("rmis_string")

local function namedtuple(typename, field_names)
    local cls = class(typename)

    function cls:initialize(...)

        print(cls, "|||", self)

        local args = { ... }
        local i = 1

        local function loop_body(v)
            if self[v] then
                error(str.f("self[{v}] 已经存在", { v = v }))
            end
            self[v] = args[i]
            i = i + 1
        end

        if type(field_names) == "string" then
            for v in string.gmatch(field_names, "[^ ]+") do
                loop_body(v)
            end
        elseif type(field_names) == "table" then
            for _, v in ipairs(field_names) do
                loop_body(v)
            end
        else
            error(str.f("field_names 的类型为 {{ type(field_names) }}，而不是 string 和 table", {
                ["type(field_names)"] = type(field_names)
            }))
        end


    end

    return cls
end

if debug.getinfo(3) == nil then
    local StrNt = namedtuple("StrNt", 1)
    local snt = StrNt("dog", 123)
    print(snt.name, snt.id)

    ---- middleclass 返回的 StrNt 是张普通表，或者说他的元表并没有实现 __call 方法
    ---- 吐槽一下，middleclass 的用法作者都没写，还是得找机会看一下源码...好像只支持单继承吧
    --print(getmetatable(StrNt))
    --local snt = StrNt("dog", 123)
    --local StrNt = class("StrNt",namedtuple("name id"))
    --local snt = StrNt("name id")


end

return {
    namedtuple = namedtuple
}