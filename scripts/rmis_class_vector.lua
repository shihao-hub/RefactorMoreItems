local g = require("rmis_global")
local str = require("rmis_string")
local Vector = require("_rmis_class_vector_local")

--local DEFAULT_CAPACITY = 3 -- Lua 表会自动扩容，所以不需要这个默认容量

local SORTED_CATEGORY = { ASC = 0, DES = 1 }

Vector.static.__apis__ = {
    "size", -- 元素总数
    "empty", -- 是否为空

    "get", -- 类比数组的 a[n]
    "put", -- 类比数组的 a[n] = x
    "insert", -- 在向量的指定秩处，插入元素，原来该位置及其之后的元素全部后移

    "remove", -- 删除指定秩处的元素，该元素后面的元素全部前移
    "sort", -- 非降序排序
    "find", -- 视序列为乱序，查找指定元素
    "disordered", -- 是否为乱序
    "search", -- 视序列为非降序，查找目标元素，返回不大于目标元素且秩最大的节点（等价于逆序查找时第一个满足条件的元素）
    "deduplicate", -- 视序列为乱序，剔除重复节点
    "uniquify", -- 视序列为非降序，剔除重复节点

    "traverse"
}

--- __add 可以实现操作符重载
---@param v Vector
function Vector:__add(v)
    g.assert(type(v) == "table" and v.isInstanceOf and v:isInstanceOf(Vector), "不是同一类型无法相加", 2)
    local res = Vector()
    for e in g.iter(self) do
        res:insert(e)
    end
    for e in g.iter(v) do
        res:insert(e)
    end
    return res
end

---@overload fun()
---@overload fun(scale:number,init_val:any)
function Vector:initialize(scale, init_val)
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
    g.untested_error()

    if self:disordered() then
        error("该函数只适用于有序向量", 2)
    end

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
    g.not_implemented_error()

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
---@param r number
---@param val any
---@return Vector 返回值是自己，类似 StringBuilder 的 append，这样可以连续调用了
function Vector:insert(r, val)
    if r and not val then
        val = r
        r = self._size + 1
    end

    self:_check_non_nil_value(val, "插入值不允许为 nil")
    self:_check_valid_rank_value(r, nil, 1, g.right_open(self._size) + 1)

    for i in g.range(self._size + 1, r, -1) do
        self.data[i] = self.data[i - 1]
    end
    self.data[r] = val
    self._size = self._size + 1
end

function Vector:insert_list(...)
    local args = { n = select("#", ...), ... }
    for i in g.range(1, g.ro(args.n)) do
        self:insert(args[i])
    end
end

--- TODO: 把 remove_range 整合进来
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
        error("该函数只适用于有序向量", 2)
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

--- 正向迭代，显然还可以加个反向迭代
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
    vec:insert_list(1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10)
    print(vec)

    print(vec:find(10))


end

return Vector
