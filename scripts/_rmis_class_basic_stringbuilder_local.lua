local g = require("rmis_global")
local class = require("rmis_middleclass")
local Object = require("rmis_class_object")

---@class BasicStringBuilder : Object
local BasicStringBuilder = class("BasicStringBuilder", Object) -- Java 的 StringBuilder

return BasicStringBuilder
