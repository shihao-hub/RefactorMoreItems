local g = require("rmis_global")

---@class UnitTest : Object
local UnitTest = g.class("UnitTest")

function UnitTest:initialize()

end


if g.debug_mode() then
    local test = UnitTest()

end



return UnitTest