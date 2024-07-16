local g = require("rmis_global")
local class = require("rmis_middleclass")
local Object = require("rmis_class_object")

---@class BiNode : Object
local BiNode = class("BiNode", Object)

function BiNode:_is_root()
    return not self.parent
end

function BiNode:_is_left_child()
    return not self:_is_root() and self.parent.lc == self
end

function BiNode:_is_right_child()
    return not self:_is_root() and self.parent.rc == self
end

function BiNode:_has_parent()
    return not self:_is_root()
end

function BiNode:_has_left_child()
    return self.lc
end

function BiNode:_has_right_child()
    return self.rc
end

function BiNode:_has_child()
    return self.lc or self.rc
end

function BiNode:_has_both_child()
    return self.lc and self.rc
end

function BiNode:_is_leaf()
    return not self:_has_child()
end

function BiNode:_get_sabling()
    return self:_is_left_child() and self.parent.rc or self.parent.lc
end

function BiNode:_get_uncle()
    g.assert(self.parent, "该节点没有父节点", 2)
    return self.parent:_is_left_child() and self.parent.parent.rc or self.parent.parent.lc
end

return BiNode
