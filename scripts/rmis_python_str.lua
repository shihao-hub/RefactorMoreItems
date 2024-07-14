local g = require("rmis_global")

local pystr = {}

-- FIXME：Python 的 replace 似乎比正则表达式性能高？
function pystr.replace(s, replaced, repl, count)
    return string.gsub(s, replaced, repl, count)
end

-- 需要了解一下，- 是什么，和我的记忆好像有偏差，但是却实现了我的想法...
-- 注意，此处其实不建议用模式匹配的，之后用 while 删除吧
function pystr.strip(s)
    return string.gsub(s, "^ *(.-) *$", "%1")
end

function pystr.lstrip(s)
    return string.gsub(s, "^ *(.+)$", "%1")
end

function pystr.rstrip(s)
    return string.gsub(s, "^(.-) *$", "%1")
end

function pystr.startswith(s, prefix)
    return string.match(s, prefix) ~= nil
end

function pystr.endswith(s, suffix)
    return string.find(s, ".+" .. suffix .. "$") ~= nil
end

-- 以 sep 为分隔符，sep 不止可以是字符，还可以是字符串
function pystr.spilt(s, sep)
    local res = {}
    for e in string.gmatch(s, "(.-)" .. sep) do
        table.insert(res, e)
    end
    if string.sub(s, #s - #sep + 1, #s) == sep then
        table.insert(res, "")
    end
    return res
end

function pystr.join(s, iterable)
    return table.concat(iterable, s)
end

if debug.getinfo(3) == nil then
    --print("|" .. pystr.strip("   abc   ") .. "|")
    ----print("|" .. pystr.strip("   abc   ") .. "|")
    ----print("|" .. pystr.lstrip("   abc   ") .. "|")
    ----print("|" .. pystr.rstrip("   abc   ") .. "|")
    --print(string.match("abcdef", "aabc"))
    --print(pystr.startswith("anb", "anb", 1))
    --print(string.find("a111", ".+" .. "111" .. "$"))

    print(g.list_tostring(pystr.spilt(",a,b,c,d,", ",")))

end

return pystr