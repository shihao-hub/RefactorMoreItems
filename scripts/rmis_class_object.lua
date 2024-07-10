local g = require("rmis_global")
local Object = require("_rmis_class_object_local")

--- 测试继承用的，不需要这个
function Object:tostring()
    return self:__tostring()
end

if debug.getinfo(3) == nil then
    print(string.byte("a"))
    print("\65")
    print("\128-\255")
end

return Object
