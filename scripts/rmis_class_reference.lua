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

return Reference