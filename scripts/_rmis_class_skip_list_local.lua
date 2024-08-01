local g = require("rmis_global")
local class = require("rmis_middleclass")
local Dictionary = require("rmis_class_dictionary")

---@class SkipList : Dictionary
local SkipList = class("SkipList", Dictionary)

return SkipList
