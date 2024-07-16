local g = require("rmis_global")

local BiNode = require("rmis_class_bi_node")
local BiTree = require("_rmis_class_bi_tree_local")

BiTree.static.__apis__ = {
    "size",
    "empty",

    "root",
    "secede",
    "insert_as_root",
    "insert_as_lc",
    "insert_as_rc",
    "attach_as_lc",
    "attach_as_rc",

    "traverse_level",
    "traverse_pre",
    "traverse_in",
    "traverse_post",

    "update_height", -- 更新当前节点的高度
    "update_height_above", -- 更新当前节点 x 及其祖先的高度
}

function BiTree:initialize()
    self._size = 0
    self._root = nil
end

function BiTree:size()
    return self._size
end

function BiTree:empty()
    return not self._root
end

function BiTree:root()
    return self._root
end

--- 插入根节点
---@param data any
---@return BiNode @ 根节点
function BiTree:insert_as_root(data)
    g.assert(self:empty(), "当前树并不为空", 2)

    self._size = 1
    local node = BiNode(data)
    self._root = node
    return node
end

---@param p BiNode
---@param data any
---@return BiNode @ 插入的新节点
function BiTree:insert_as_lc(p, data)
    self._size = self._size + 1
    return p:insert_as_lc(data)
end

---@param p BiNode
---@param data any
---@return BiNode @ 插入的新节点
function BiTree:insert_as_rc(p, data)
    self._size = self._size + 1
    return p:insert_as_rc(data)
end

if debug.getinfo(3) == nil then
    local tree = BiTree()
    local root = tree:insert_as_root(111)
    print(root:tostring())
    local left = tree:insert_as_lc(root, 1110)
    local right = tree:insert_as_rc(root, 1111)
    print(root:tostring())
    local left_left = tree:insert_as_lc(left, 11100)
    local left_right = tree:insert_as_rc(left, 11101)
    local right_left = tree:insert_as_lc(right, 11110)
    local right_right = tree:insert_as_rc(right, 11111)
    print(root:tostring())
    print(339 / 382)
end

return BiTree
