local g = require("rmis_global")
local ListNode = require("rmis_class_list_node")

local List = require("_rmis_class_list_local")

List.static.__apis__ = {
    "size",
    "first",
    "last",
    "insert_as_first",
    "insert_as_last",
    "insert_before",
    "insert_after",
    "remove",
    "disordered",
    "sort",
    "find",
    "search",
    "deduplicate",
    "uniquify",
    "traverse",
}

function List:initialize()
    -- 哨兵，指向头尾
    self.header = ListNode(nil, nil, nil)
    self.trailer = ListNode(nil, nil, nil)
    self.header.succ = self.trailer
    self.trailer.pred = self.header
    self._size = 0
end

function List:size()
    return self._size
end

function List:empty()
    return self._size == 0
end

function List:first()
    return self.header.succ
end

function List:last()
    return self.trailer.pred
end

--- 时间复杂度 O(1)
function List:insert_as_first(data)
    self._size = self._size + 1
    return self.header:insert_as_succ(data)
end

--- 时间复杂度 O(1)
function List:insert_as_last(data)
    self._size = self._size + 1
    return self.trailer:insert_as_pred(data)
end

--- 时间复杂度 O(1)
---@param p ListNode
function List:insert_before(p, data)
    self._size = self._size + 1
    return p:insert_as_pred(data)
end

--- 时间复杂度 O(1)
---@param p ListNode
function List:insert_after(p, data)
    self._size = self._size + 1
    return p:insert_as_succ(data)
end

---@param p ListNode
---@return any
function List:remove(p)
    local res = p.data
    p.pred.succ = p.succ
    p.succ.pred = p.pred
    self._size = self._size - 1
    return res
end

function List:disordered()

end

function List:sort(p, n)
    -- 随机选取排序算法，测试用。
    local rand = math.random(1, 3)
    local switch = {
        [1] = function()
            return self:_insertion_sort(p, n)
        end,
        [2] = function()
            return self:_selection_sort(p, n)
        end,
        [3] = function()
            return self:_merer_sort(p, n)
        end
    }
    return switch[rand]
end

function List:find()

end

function List:search()
    if self:disordered() then
        error("该函数只适用于有序链表")
    end

end

function List:deduplicate()

end

function List:uniquify()
    if self:disordered() then
        error("该函数只适用于有序链表")
    end

end

function List:traverse(fn)
    local p = self.header
    return function()
        p = p.succ
        if p == self.trailer then
            return nil
        end
        p.data = fn(p.data)
        return p.data
    end
end

function List:__tostring()
    return self:_tostring("[","]")
end


if debug.getinfo(3) == nil then
    local list = List()
    print(list)
    list:insert_as_last(1)
    print(list)
    list:insert_as_last(2)
    list:insert_as_last(3)
    list:insert_as_last(4)
    print(list)
    for e in list:traverse(tostring) do
        print(e)
    end
    print(list)
end

return List
