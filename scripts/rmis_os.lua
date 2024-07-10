local g = require("rmis_global")
local ost = setmetatable({}, { __index = os })

function ost.create_dir(dirname)
    g.not_implemented_error()

    local status, flag, flag_code = os.execute("mkdir" .. " " .. dirname)

    if not status then
        print(g.f "warning: status = {{status}}", { status = status })
    end
    if not flag then
        print(g.f "warning: flag = {{flag}}", { flag = flag })
    end

    return status, flag, flag_code
end

return ost
