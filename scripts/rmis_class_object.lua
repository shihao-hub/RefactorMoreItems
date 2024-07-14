local g = require("rmis_global")
local Object = require("_rmis_class_object_local")

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
