local g = require("rmis_global")
local str = require("rmis_string")
local ListNode = require("_rmis_class_list_node_local")

ListNode.static.__apis__ = {
    "insert_as_pred",
    "insert_as_succ",
}

---@param data any|nil
---@param pred ListNode|nil
---@param succ ListNode|nil
function ListNode:initialize(data, pred, succ)
    self.data = data
    self.pred = pred
    self.succ = succ
end

--- 插入前驱节点，存入数据，返回新节点
---@return ListNode
function ListNode:insert_as_pred(data)
    local node = ListNode(data, self.pred, self)
    self.pred.succ = node
    self.pred = node
    return node
end

--- 插入后继节点，存入数据，返回新节点
---@return ListNode
function ListNode:insert_as_succ(data)
    local node = ListNode(data, self, self.succ)
    self.succ.pred = node
    self.succ = node
    return node
end

function ListNode:tostring()
    return str.format("<%s, %s, %s>", self.data, self.pred, self.succ)
end

return ListNode
