local g = require("rmis_global")
local iot = setmetatable({}, { __index = io })

function iot.reach_file_end(file)
    -- file:read(0) 如果到达文件结尾则返回 nil，否则返回空字符串
    return file:read(0) == nil
end

--- 会保留换行符
function iot.lines(filepath)
    local file = io.open(filepath, "r")
    if not file then
        error(g.f("文件 `{{path}}` 不存在", { path = filepath }), 2)
    end
    return function()
        local res = file:read("*line").."\n"
        if not res then
            file:close()
        end
        return res
    end
end

if debug.getinfo(3) == nil then
    for line in iot.lines("tests/test.lua") do
        print(line)
    end

end

return iot