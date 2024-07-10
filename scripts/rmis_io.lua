local g = require("rmis_global")
local iot = setmetatable({}, { __index = io })

---@param path_or_file string|file
---@return number 单位为字节
function iot.get_file_size(path_or_file)
    local is_file = type(path_or_file) ~= "string"
    local file = is_file and path_or_file or io.open(path_or_file, "r")

    local cur = file:seek()
    local res = file:seek("end")
    file:seek("set", cur)

    if not is_file then
        file:close()
        file = nil
    end
    return res
end

function iot.write_and_flush(...)
    io.write(...)
    io.flush()
end

function iot.popen(...)
    g.not_implemented_error()
end



if debug.getinfo(3) == nil then
    print(iot.get_file_size(io.open("tests/test.lua", "r")))
    iot.write_and_flush("1","2","3")
end

return iot
