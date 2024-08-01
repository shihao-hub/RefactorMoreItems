local g = require("rmis_global")

local Reference = require("_rmis_class_reference_local")

function Reference:initialize(value)
    self.value = value
end

function Reference:get_value()
    return self.value
end

function Reference:set_value(value)
    self.value = value
end

if g.debug_mode() then
    local ref = Reference(123)
    print(ref:get_value())
    ref:set_value("abc")
    print(ref:get_value())
end

return Reference