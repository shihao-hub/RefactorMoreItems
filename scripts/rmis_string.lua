local g = require("rmis_global")

local str = setmetatable({}, {
    __index = string,
    __call = function(t, val)
        return tostring(val)
    end
})

--- 类似 string.format，但是传入的所有参数都会调用 tostring
function str.format(formatstring, ...)
    return string.format(formatstring, unpack(g.map(tostring, { n = select("#", ...), ... })))
end

function str.iter(s)
    local i = 0
    return function()
        i = i + 1
        if i > #s then
            return nil
        end
        return string.sub(s, i, i)
    end
end

if debug.getinfo(3) == nil then
    for e in str.iter("abc") do
        print("--" .. e)
    end
end

return str
