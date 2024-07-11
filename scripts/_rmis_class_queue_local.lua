local g = require("rmis_global")
local class = require("rmis_middleclass")
local Object = require("rmis_class_object")
local List = require("rmis_class_list")


---@class Queue : List
local Queue = class("Queue",List)


return Queue
