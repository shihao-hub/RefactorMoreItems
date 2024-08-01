local g = require("rmis_global")
local class = require("rmis_middleclass")
local Dictionary = require("rmis_class_dictionary")

---@class HashTable : Dictionary
local HashTable = class("HashTable", Dictionary)

return HashTable
