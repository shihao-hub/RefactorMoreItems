local g = require("rmis_global")

local str = setmetatable({}, {
    __index = string,
    __call = function(t, val)
        return tostring(val)
    end
})

--- 类似 string.format，但是传入的所有参数都会调用 tostring
function str.format(formatstring, ...)
    return string.format(formatstring, unpack(g.map(tostring, { ... })))
end

function str.replace(s, replaced, repl, count)
    return string.gsub(s, replaced, repl, count)
end

if debug.getinfo(3) == nil then

end

return str
