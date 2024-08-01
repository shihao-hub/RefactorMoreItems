local g = require("rmis_global")

local Vector = require("rmis_class_vector")
local HashTable = require("_rmis_class_hashtable_local")

function HashTable:initialize()
    -- 由于 middleclass.lua 不支持多重继承，因此用组合代替
    self.vector = Vector()
end



function HashTable:size()
    g.subclass_responsibility_error()
end

function HashTable:get(key)
    g.subclass_responsibility_error()
end

function HashTable:put(key, value)
    g.subclass_responsibility_error()
end

function HashTable:remove(key)
    g.subclass_responsibility_error()
end

function HashTable:__tostring()
    return "key1=value1;key2=value2;..."
end

if debug.getinfo(3) == nil then
    print(string.format("%f",2^63-1))
    print(#("9223372036854775800"))
    print(54/218)
    print(82/218)
end

return HashTable
