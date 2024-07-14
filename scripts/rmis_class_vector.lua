local g = require("rmis_global")
local str = require("rmis_string")
local Vector = require("_rmis_class_vector_local")

--local DEFAULT_CAPACITY = 3 -- Lua 表会自动扩容，所以不需要这个默认容量

local SORTED_CATEGORY = { "ASC", "DES" }

Vector.static.__apis__ = {
    "size",
    "empty",
    "get",
    "put",
    "insert",
    "remove",
    "disordered",
    "sort",
    "find",
    "search",
    "deduplicate",
    "uniquify",
    "traverse"
}

---@overload fun()
function Vector:initialize(scale, init_val)
    --Vector.super:initialize(scale, init_val)
    --print(self)

    if scale then
        self:_check_non_nil_value(init_val)
    end

    scale = scale or 0

    self._size = scale
    self.data = {}
    for i in g.range(g.right_open(scale)) do
        self.data[i] = init_val
    end

    self.sored_category = nil -- future
end

function Vector:size()
    return self._size
end

function Vector:empty()
    return self._size == 0
end

function Vector:get(r)
    self:_check_valid_rank_value(r, 1, g.right_open(self._size))

    return self.data[r]
end

function Vector:put(r, e)
    self:_check_non_nil_value(e, "不允许赋值为 nil")
    self:_check_valid_rank_value(r, nil, 1, g.right_open(self._size))

    self.data[r] = e
    self._size = self._size + 1
end

--- 查找等于 e 且秩最大的元素，[lo, hi)
---@overload fun(e:any):boolean
---@return number @ -1 代表没找到
function Vector:find(e, lo, hi)
    g.untested_error()

    lo = lo or 1
    hi = hi or self._size + 1
    for i in g.range(hi - 1, lo - 1, -1) do
        if self.data[i] == e then
            return i
        end
    end
    return -1
end

--- 这是向量啊，可以用二分查找
function Vector:search(e, lo, hi)
    if self:disordered() then
        error("该函数只适用于有序向量")
    end

    g.untested_error()

    while lo < hi do
        local mid = (lo + hi) / 2
        if e < self.data[mid] then
            hi = mid -- 注意，左闭右开，所以 hi = mid，而不是 mid - 1
        elseif e > self.data[mid] then
            lo = lo + 1
        else
            return mid
        end
    end
    return -1

end

--- 非降序，[start_pos, end_pos)
---@overload fun()
function Vector:sort(start_pos, end_pos)
    if not start_pos and not end_pos then
        start_pos = 1
        end_pos = g.right_open(self:size())
    end
    -- 随机选取排序算法，测试用。
    local rand = math.random(1, 3)
    local switch = {
        [1] = function()
            return self:_insertion_sort(start_pos, end_pos)
        end,
        [2] = function()
            return self:_selection_sort(start_pos, end_pos)
        end,
        [3] = function()
            return self:_merer_sort(start_pos, end_pos)
        end
    }
    return switch[rand]
end

--- e 作为秩为 r 元素插入，原后继元素依次后移
--- 如果 r 置空，则视为尾插法
---@overload fun(e:any):Vector
---@return Vector 返回值是自己，类似 StringBuilder 的 append，这样可以连续调用了
function Vector:insert(r, e)
    if r and not e then
        e = r
        r = self._size + 1
    end

    self:_check_non_nil_value(e, "插入值不允许为 nil")
    self:_check_valid_rank_value(r, nil, 1, g.right_open(self._size) + 1)

    for i in g.range(self._size + 1, r, -1) do
        self.data[i] = self.data[i - 1]
    end
    self.data[r] = e
    self._size = self._size + 1
    return self
end

function Vector:remove(r)
    local res = self.data[r]
    self:remove_range(r, r + 1)
    return res
end

--- 删除区间的时候与 C++ 匹配，[lo,hi)，保证统一！
---@return number 返回被删除元素的数目
function Vector:remove_range(lo, hi)
    -- 只能删除 [1,len]，左闭右开，那么应该只能输入 [1,len+1)
    assert(lo < hi and lo >= 1 and hi <= g.right_open(self._size),
            g.f("输入的区间 [{{lo}}, {{hi}}) 不是 [1, {{right}}) 的子集", { lo = lo, hi = hi, right = g.right_open(self._size) }))

    -- 方法一
    --local interval_len = hi - lo + 1
    --for i in g.range(lo, self._size - interval_len + 1) do
    --    self.data[i] = self.data[i + interval_len]
    --end
    --self._size = self._size - interval_len

    -- 方法二，要注意这个，Lua 写久了 C 思维会退化的（方法一也还行，但是不是 C++ 风格，应该是 Java 风格）
    while hi < g.right_open(self._size) do
        self.data[lo] = self.data[hi]
        lo = lo + 1
        hi = hi + 1
    end
    self:_shrink_the_interval(lo, g.right_open(self._size))
    return hi - lo
end

--- 如果向量 S 中的所有元素不仅按线性次序存放，而且其数值大小也按此次序单调分布，则称作有序向量
--- 有序向量不要求元素互异，通常约定其中的元素自前向后构成一个非降序列
--- 目前假设元素都可以比较大小
function Vector:disordered()
    for i in g.range(2, g.right_open(self._size)) do
        if self.data[i - 1] > self.data[i] then
            return true
        end
    end
    return false
end

--- uniquify: 唯一的，就是去重
function Vector:uniquify()
    if self:disordered() then
        error("该函数只适用于有序向量")
    end

    -- 时间复杂度高达 O(n^2)
    --local removed_index = {}
    --for i in g.range(2, self._size + 1) do
    --    if self.data[i] == self.data[i - 1] then
    --        table.insert(removed_index, i)
    --    end
    --end
    --for i in g.range(#removed_index + 1) do
    --    self:remove(removed_index[i] - i + 1) -- 调用删除操作的时候索引会变动，所以既然如此，此处的代码显然可以放入上面的循环中。
    --end

    -- 改进一下，但是还不能算最优。因为这里不是书中的实现，是我自己的实现
    for i in g.range(2, g.right_open(self._size)) do
        if self.data[i] == self.data[i - 1] then
            self.data[i - 1] = nil -- 注意，是 i-1
        end
    end

    local i, j = 1, 1
    local old_len = self._size
    while j <= old_len do
        if self.data[j] then
            self.data[i] = self.data[j]
            i = i + 1
        end
        j = j + 1
    end
    --self._size = i - 1 -- 直接截除后面的内容，但是说实在的，不太好，因为并没有实现 shrink 缩容函数，因为不需要扩容，如果这样的话，截除并不合适
    self:_shrink_the_interval(i, g.right_open(self._size))
    i, j = nil, nil
end

--- 遍历元素并统一处理所有元素，处理方法由函数对象指定
--- 这个处理方法必须要有返回值，传入的元素经过处理再返回回来
function Vector:traverse(fn)
    g.not_implemented_error()
    print("WARNING: 当前调用的函数会修改元素本身，请注意")
    -- 这里不能复用 __iter__，因为这里既读又写
    -- FIXME: 这个函数有用吗，暂且搁置
    local i = 0
    return function()
        i = i + 1
        self.data[i] = fn(self.data[i])
        return self.data[i]
    end
end

function Vector:__iter__()
    local i = 0
    return function()
        i = i + 1
        return self.data[i]
    end
end

function Vector:__tostring()
    return g.list_tostring(self.data, 1, self._size)
end

if debug.getinfo(3) == nil then
    -- TODO:
    -- 还是需要了解一下 TTD 的，写好测试用例，但是真的好麻烦呀...
    -- 我觉得不该如此麻烦...
    -- 单元测试太重要了呀...不然每次改动都不能保证改动有没有问题...

    local vec = Vector()
    --vec:put(1, 1)
    --vec:put(2, 2)
    --vec:put(3, 3)
    --vec:put(4, 3)
    --vec:put(5, 4)
    --vec:put(6, 4)
    --vec:put(7, 5)
    --vec:put(8, 5)
    --vec:put(9, 5)
    --vec:put(10, 6)
    vec:insert(1):insert(2):insert(3):insert(3):insert(3):insert(4):insert(5):insert(6):insert(7):insert(8):insert(9):insert(9):insert(9):insert(10)
    print(vec)
    for e in g.iter(vec) do
        print(e)
    end
    print(vec:find(3))
    --print(vec:size())
    --vec:remove_range(1, 16)
    --print(vec)
    --vec:uniquify()
    --print(vec)

    --print(vec:remove(8))
    --print(vec)
    --print(vec:remove_range(2, 4))
    --print(vec)


    --vec:uniquify()
    --print(vec)

    --vec:remove()
    --vec:remove(4)
    --print(vec)
    --vec:remove(6)
    --print(vec)

    --print(vec:disordered())
    --print(vec)
    --vec:insert(3, 4)
    --print(vec:disordered())
    --vec:uniquify()
    --print(vec)
    --vec:remove(3)
    --print(vec:disordered())
    --vec:remove(1)
    --print(vec:disordered())
    --print(vec)

end

return Vector
