local g = require("rmis_global")
local str = require("rmis_string")
local BiNode = require("_rmis_class_bi_node_local")

BiNode.static.__apis__ = {
    "size", -- 统计当前节点的后代总数，亦即以其为根的子树的规模
    "insert_as_lc", -- 当前节点插入左孩子（如果之前没有左孩子才行）
    "insert_as_rc", -- 当前节点插入右孩子（如果之前没有右孩子才行）

    "traverse_level", -- 联想：ListNode 就是线性结构，所以不需要遍历函数，当然其实 ListNode 也可以加个 traverse，但是没必要
    "traverse_pre",
    "traverse_in",
    "traverse_post",

    "succ",
}

BiNode.static.RBColor = { red = 1, black = 2 }

---@param parent BiNode|nil
---@param lc BiNode|nil
---@param rc BiNode|nil
function BiNode:initialize(data, parent, lc, rc, height, npl, color)
    -- emmy lua helper
    if not BiNode.RBColor then
        BiNode.RBColor = BiNode.static.RBColor
    end

    -- 注意一下，此处和列表一样的设计，非常好，一个节点初始化的时候可以设置前驱和后继之类的
    -- 以二叉树为例，BiTree 封装 BiNode
    -- 以链表为例，List 封装 ListNode
    self.data = data
    self.parent = parent
    self.lc = lc
    self.rc = rc
    -- 以下部分是二叉树拓展需要用的
    self.height = height or 0
    self.npl = npl or 1 -- 左式堆
    self.color = color or BiNode.RBColor.red -- 红黑树
end

--- 默认认为原来就没有左孩子
function BiNode:insert_as_lc(data)
    g.assert(not self:_has_left_child(), "当前节点已经有左孩子了，不允许再插入", 2)

    local node = BiNode(data, self)
    self.lc = node
    return node
end

function BiNode:insert_as_rc(data)
    g.assert(not self:_has_right_child(), "当前节点已经有右孩子了，不允许再插入", 2)

    local node = BiNode(data, self)
    self.rc = node
    return node
end

function BiNode:tostring()
    local hash_object = g.hash_object
    return str.format("<%s, %s, %s, %s>",
            self.data, hash_object(self.parent),
            self.lc and self.lc:tostring() or hash_object(self.lc),
            self.rc and self.rc:tostring() or hash_object(self.rc))
end

if debug.getinfo(3) == nil then
    local tree = BiNode(0)
    tree:insert_as_lc(1)
    tree:insert_as_rc(2)
    print(tree:tostring())
end

return BiNode
