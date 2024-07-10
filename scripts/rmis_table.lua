local g = require("rmis_global")
local tab = setmetatable({
    keys = g.keys, values = g.values
}, { __index = table })

--- 将表实例化为字符串，如果其中存在共享子表等，则打印其内存地址。
--- 注意，有点问题，序列化主要应该类似 json 那样，string 才能序列化...
function tab.serialize(t, cycle, indent)
    indent = indent or 1
    local function first_time_in()
        return indent == 1
    end
    if cycle then
        g.not_implemented_error()
    end
    if g.contain({ "number", "string", "boolean", "nil" }, type(t)) then
        io.write(string.format("%q", tostring(t)))
    elseif type(t) == "table" then
        io.write("{\n")
        for k, v in pairs(t) do
            io.write(string.rep(" ", 4 * indent), str.format("[%q]", k), " = ")
            tab.serialize(v, cycle, indent + 1)
            if type(v) ~= "table" then
                io.write(",\n")
            end
        end
        if first_time_in() then
            io.write("}\n")
        else
            io.write(string.rep(" ", 4 * (indent - 1)), "},\n")
        end
    else
        error(g.f("出现不适配的类型：{{ type(t) }}", { ["type(t)"] = type(t) }))
    end


end

if debug.getinfo(3) == nil then
    print(tab.serialize({
        ["1"] = "1",
        ["2"] = {
            ["3"] = "3",
            ["4"] = {
                ["5"] = "5",
                [6] = {
                    [7] = true,
                    [8] = nil,
                    [9] = 1
                }
            }
        }
    }))
end

return tab
