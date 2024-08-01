local g = require("rmis_global")

local Dictionary = require("_rmis_class_dictionary_local")

Dictionary.static.__apis__ = {
    "size", -- 当前词条总数
    "get", -- 存在则返回，不存在则返回 nil
    "put", -- 插入词条 (key,value)，并报告是否成功
    "remove", -- 若词典中存在以 key 为关键码的词条，则删除并返回 true，否则，返回 false
}


function Dictionary:size()
    g.subclass_responsibility_error()
end

function Dictionary:get(key)
    g.subclass_responsibility_error()
end

function Dictionary:put(key, value)
    g.subclass_responsibility_error()
end

function Dictionary:remove(key)
    g.subclass_responsibility_error()
end


return Dictionary
