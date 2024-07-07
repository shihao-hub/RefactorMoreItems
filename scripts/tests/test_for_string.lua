local str = require("rmis_string")

local writer = function(...)
    return io.stderr:write(...)
end

local function test_for_format()
    require("debug")
    local res = str.format("%s %s %s", nil, true, 1)
    local info = debug.getinfo(1)
    if res ~= "nil true 1" then
        writer(string.format("%s `%s(...):%s:%s`", "Failure in ", info.name, info.short_src, info.linedefined))
    else
        writer(string.format("%s `%s(...):%s:%s`", "Success in", info.name, info.short_src, info.linedefined))
    end
end

--test_for_format()

local function test_for_f()
    print(str.f("|{{{name}}} {value}|", { name = "--name--", value = "--value--", }))
end
test_for_f()