local g = require("rmis_global")

local SkipList = require("_rmis_class_skip_list_local")

function SkipList:initialize()

end

function SkipList:size()
    g.subclass_responsibility_error()
end

function SkipList:get(key)
    g.subclass_responsibility_error()
end

function SkipList:put(key, value)
    g.subclass_responsibility_error()
end

function SkipList:remove(key)
    g.subclass_responsibility_error()
end

function SkipList:__tostring()
    return "key1=value1;key2=value2;..."
end

if debug.getinfo(3) == nil then
    local skip = SkipList()
end

return SkipList
