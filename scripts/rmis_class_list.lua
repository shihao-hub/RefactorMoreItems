local g = require("rmis_global")
local class = require("rmis_middleclass")
local Object = require("rmis_class_object")
local Vector = require("rmis_class_vector")

---@class Stack : Vector
local Stack = class("Stack", Vector)

return Stack
