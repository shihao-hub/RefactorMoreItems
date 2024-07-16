local g = require("rmis_global")
local Object = require("_rmis_class_object_local")

--- 注意，这个 hash 不一样，如果类就返回地址，如果是其他，则返回它自身
function Object.hash_object(obj)
    return obj and (obj.hash and obj:hash()) or obj
end

function Object.tostring_object(obj)
    return obj and (obj.hash and obj:hash()) or obj
end

function Object:tostring()
    g.subclass_responsibility_error()
end


function Object:get_class()
    return "class " .. self.class.name
end

--- 默认是比较地址，所以需要重写
function Object:equals(obj)
    return self == obj
end

function Object:hash()
    local meta = getmetatable(self)
    local old = meta.__tostring
    meta.__tostring = nil
    local res = string.sub(tostring(self),8)
    meta.__tostring = old
    return res
end

if debug.getinfo(3) == nil then
    --print(string.byte("a"))
    --print("\65")
    --print("\128-\255")
    local obj = Object()
    print(obj:get_class())
    print(obj:equals(Object()))
    print(obj:tostring())
end

return Object
