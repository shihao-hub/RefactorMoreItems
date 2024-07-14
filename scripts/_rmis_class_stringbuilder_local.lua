local g = require("rmis_global")
local class = require("rmis_middleclass")
local BasicStringBuilder = require("_rmis_class_basic_stringbuilder_local")

---@class StringBuilder : BasicStringBuilder
local StringBuilder = class("StringBuilder", BasicStringBuilder) -- Java 的 StringBuilder

return StringBuilder
