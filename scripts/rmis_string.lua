local g = require("rmis_global")

local str = setmetatable({}, {
    __index = string,
    __call = function(t, val)
        return tostring(val)
    end
})

function str.format(formatstring, ...)
    return string.format(formatstring, unpack(g.map(tostring, { ... })))
end

---试图模仿 python 的 f
function str.f(formatstring, data)
    return (string.gsub(formatstring, "{{ *([()A-Za-z0-9_]+) *}}", function(v)
        -- 捕获到的内容是这个 v
        if not data[v] then
            error("str.f 格式存在问题", 4)
        end
        return string.format("%q", tostring(data[v]))
    end))
end

return str