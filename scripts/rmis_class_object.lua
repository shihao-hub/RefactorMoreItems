local g = require("rmis_global")
local Object = require("_rmis_class_object_local")

--- 测试继承用的，不需要这个
function Object:tostring()
    return tostring(self)
end


function Object:get_class()
    return tostring(self)
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
