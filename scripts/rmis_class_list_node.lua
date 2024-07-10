local g = require("rmis_global")
local ListNode = require("_rmis_class_list_node_local")

ListNode.static.__apis__ = { "insert_as_pred", "insert_as_succ", "size", "first", "last", "insert_as_first", "insert_as_last" }

---@param data any
---@param pred ListNode
---@param succ ListNode
function ListNode:initialize(data, pred, succ)
    self.data = data
    self.pred = pred or nil
    self.succ = succ or nil
end

function ListNode:size()

end

--- 删除位置 p 处的节点，返回其数值
---@param p ListNode
function ListNode:remove(p)

end

function ListNode:size()

end

---@param e ListNode
function ListNode:insert_as_first(e)

end

---@param e ListNode
function ListNode:insert_as_last(e)

end

--- 紧靠当前节点之前插入新节点
---@param p ListNode
---@param e ListNode
function ListNode:insert_as_pred(p, e)

end

--- 紧靠当前节点之后插入新节点
---@param p ListNode
---@param e ListNode
function ListNode:insert_as_succ(p, e)

end

return ListNode
