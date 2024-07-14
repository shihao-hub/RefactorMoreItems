local g = require("rmis_global")
local class = require("rmis_middleclass")
local Object = require("rmis_class_object")

---@class List : Object
local List = class("List", Object)


---@param p ListNode
---@param n number
function List:_insertion_sort(p, n)
    for _ in g.range(1,g.right_open(n)) do

        p = p.succ
    end
end

---@param p ListNode
---@param n number
function List:_selection_sort(p, n)

end

function List:_merge()

end

---@param p ListNode
---@param n number
function List:_merer_sort(p, n)

end

function List:_tostring(left_char, right_char)
    local res = {}
    table.insert(res, left_char)
    local p = self.header
    while true do
        p = p.succ
        if p == self.trailer then
            break
        end
        table.insert(res, g.f("{{data}}" .. (p.succ ~= self.trailer and ", " or ""), { data = p.data }))
    end
    table.insert(res, right_char)
    return table.concat(res)
end

return List
