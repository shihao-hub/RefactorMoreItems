local g = require("rmis_global")
local ListNode = require("rmis_class_list_node")

local List = require("_rmis_class_list_local")

List.static.__apis__ = {
    "size", -- 节点总数
    "empty", -- 是否为空

    "first", -- 首节点的位置（可能为 trailer）
    "last", -- 尾节点的位置（可能为 header）
    "insert_as_first", -- 头插法
    "insert_as_last", -- 尾插法
    "insert_before", -- 插到某个节点的前面
    "insert_after", -- 插到某个节点的后面

    "remove", -- 删除某个节点
    "sort", -- 非降序排序
    "find", -- 视序列为乱序，查找指定元素
    "disordered", -- 是否为乱序
    "search", -- 视序列为非降序，查找目标元素，返回不大于目标元素且秩最大的节点（等价于逆序查找时第一个满足条件的元素）
    "deduplicate", -- 视序列为乱序，剔除重复节点
    "uniquify", -- 视序列为非降序，剔除重复节点

    "traverse", -- 这个的定义有待商榷
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

-- FIXME
function List:first()
    return self.header.succ
end

-- FIXME
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
    local pre
    for e in g.iter(self) do
        if not pre then
            pre = e
        else
            if pre.data > e.data then
                return true
            end
            pre = e
        end
    end
    return false
end

--- 对起始与 p 的 n 个元素排序
---@overload fun()
---@param p ListNode
---@param n number
function List:sort(p, n)
    g.not_implemented_error()

    if not p and not n then
        p = self:first()
        n = self:size()
    end

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

--- 节点 p 的 n 个真前驱中，找到等于 data 的最后者
---@param data any
---@param n number
---@param p ListNode
---@return ListNode|nil
function List:find(data, n, p)
    local cur = p
    local res
    -- 用区间的左开右闭类似的思想确定边界值很舒服
    for _ in g.range(n, 0, -1) do
        cur = cur.pred
        if cur == self.header then
            break
        end
        if cur.data == data then
            res = cur
        end
    end
    return res
end

--- 在有序列表内节点 p 的 n 个真前驱中（所以不考虑 p 自己），找到不大于 data 的最后者
---@param data any
---@param n number
---@param p ListNode
---@return ListNode|nil
function List:search(data, n, p)
    g.untested_error()

    if self:disordered() then
        error("该函数只适用于有序链表", 2)
    end

    local cur = p
    for _ in g.range(n, 0, -1) do
        cur = cur.pred
        if cur == self.header then
            break
        end
        if cur.data <= data then
            return cur -- 最后者是只从右往左第一个？
        end
    end
    return nil
end

function List:deduplicate()
    g.not_implemented_error("List:deduplicate()")
end

function List:uniquify()
    g.not_implemented_error("List:uniquify()")

    if self:disordered() then
        error("该函数只适用于有序链表", 2)
    end
end

function List:traverse(fn)
    g.not_implemented_error("List:traverse(fn)")

    print("WARNING: 当前调用的函数会修改元素本身，请注意")
    local generator = g.iter(self)
    return function()
        local cur = generator()
        if not cur then
            return nil
        end
        cur.data = fn(cur.data)
        return cur.data
    end
end

-- TODO：深入 Python，把 Python 优秀的东西用 Lua 模拟实现一下！尤其鸭子类型！
function List:__iter__()
    local p = self.header
    return function()
        p = p.succ
        if p == self.trailer then
            return nil
        end
        return p
    end
end

function List:__tostring()
    return self:_tostring("[", "]")
end

if debug.getinfo(3) == nil then
    local list = List()
    print(list)
    list:insert_as_last(1)
    print(list)
    list:insert_as_last(2)
    list:insert_as_last(3)
    list:insert_as_last(4)
    list:search()
    print(list)
    print(list:disordered())
    list:insert_as_last(3)
    list:insert_as_last(3)

    print(list)
    print(list:last().data)
    print(list:find(3, 10, list:last()).data)
    print(list:disordered())
    list:deduplicate()
    --for e in g.iter(require("rmis_class_vector")()) do
    --    print("--", e)
    --end
    --for e in list:traverse(tostring) do
    --    print(type(e), e)
    --end
end

return List
