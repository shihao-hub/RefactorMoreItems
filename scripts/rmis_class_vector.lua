local g = require("rmis_global")
local str = require("rmis_string")

local Vector = require("_rmis_class_vector_local")

--local DEFAULT_CAPACITY = 3 -- Lua 表会自动扩容，所以不需要这个默认容量

local SORTED_CATEGORY = { "ASC", "DES" }

Vector.static.__apis__ = { "size", "get", "put", "insert", "remove", "disordered", "sort", "find", "search", "deduplicate", "uniquify", "traverse" }

---@overload fun()
function Vector:initialize(scale, init_val)

    if scale then
        self:_check_non_nil_value(init_val)
    end

    scale = scale or 0

    self.len = scale
    self.data = {}
    for i in g.range(scale + 1) do
        self.data[i] = init_val
    end

    self.sored_category = nil -- ?
end

function Vector:size()
    return self.len
end

function Vector:get(r)
    self:_check_valid_rank_value(r)
    return self.data[r]
end

function Vector:put(r, e)
    self:_check_non_nil_value(e, "不允许赋值为 nil")
    self:_check_valid_rank_value(r, nil, 1, self.len + 1)

    self.data[r] = e
    self.len = self.len + 1
end

--- 查找等于 e 且秩最大的元素，[lo, hi)
---@overload fun(e:any):boolean
function Vector:find(e, lo, hi)
    lo = lo or 1
    hi = hi or self.len - 1
    for i in g.range(hi - 1, lo - 1, -1) do
        if self.data[i] == e then
            return true
        end
    end
    return false
end

function Vector:search(e)
    if self:disordered() then
        error("该函数只适用于有序向量")
    end

    g.not_implemented_error()


end

function Vector:sort()
    g.not_implemented_error()

    -- 非降序
end

--- e 作为秩为 r 元素插入，原后继元素依次后移
--- 如果 r 置空，则视为尾插法
---@overload fun(e:any):Vector
---@return Vector 返回值是自己，类似 StringBuilder 的 append，这样可以连续调用了
function Vector:insert(r, e)
    if r and not e then
        e = r
        r = self.len + 1
    end

    self:_check_non_nil_value(e, "插入值不允许为 nil")
    self:_check_valid_rank_value(r, nil, 1, self.len + 1)

    for i in g.range(self.len + 1, r, -1) do
        self.data[i] = self.data[i - 1]
    end
    self.data[r] = e
    self.len = self.len + 1
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
    assert(lo < hi and lo >= 1 and hi < self.len + 1, "assert: lo < hi and lo >= 1 and hi < self.len + 1")

    -- 方法一
    --local interval_len = hi - lo + 1
    --for i in g.range(lo, self.len - interval_len + 1) do
    --    self.data[i] = self.data[i + interval_len]
    --end
    --self.len = self.len - interval_len

    -- 方法二，要注意这个，Lua 写久了 C 思维会退化的
    while hi < self.len + 1 do
        self.data[lo] = self.data[hi]
        lo = lo + 1
        hi = hi + 1
    end
    --self.len = lo - 1
    self:_shrink_the_interval(lo, self.len)

    -- 注意：这个不需要，有 self.len 限制就行了！
    --for i in g.range(self.len + 1, old_len + 1) do
    --    self.data[i] = nil
    --end

    return hi - lo
end

--- 如果向量 S 中的所有元素不仅按线性次序存放，而且其数值大小也按此次序单调分布，则称作有序向量
--- 有序向量不要求元素互异，通常约定其中的元素自前向后构成一个非降序列
--- 目前假设元素都可以比较大小
function Vector:disordered()
    for i in g.range(self.len) do
        if self.data[i] > self.data[i + 1] then
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
    --for i in g.range(2, self.len + 1) do
    --    if self.data[i] == self.data[i - 1] then
    --        table.insert(removed_index, i)
    --    end
    --end
    --for i in g.range(#removed_index + 1) do
    --    self:remove(removed_index[i] - i + 1) -- 调用删除操作的时候索引会变动，所以既然如此，此处的代码显然可以放入上面的循环中。
    --end

    -- 改进一下，但是还不能算最优
    for i in g.range(2, self.len + 1) do
        if self.data[i] == self.data[i - 1] then
            self.data[i - 1] = nil -- 注意，是 i-1
        end
    end

    local i, j = 1, 1
    local old_len = self.len
    while j <= old_len do
        if self.data[j] then
            self.data[i] = self.data[j]
            i = i + 1
        end
        j = j + 1
    end
    --self.len = i - 1 -- 直接截除后面的内容，但是说实在的，不太好，因为并没有实现 shrink 缩容函数，因为不需要扩容，如果这样的话，截除并不合适
    self:_shrink_the_interval(i, self.len)
    i, j = nil, nil
end

--- 遍历元素并统一处理所有元素，处理方法由函数对象指定
--- 这个处理方法必须要有返回值，传入的元素经过处理再返回回来
function Vector:traverse(fn)
    local i = 0
    return function()
        i = i + 1
        self.data[i] = fn(self.data[i])
        return self.data[i]
    end
end

function Vector:__tostring()
    return g.list_tostring(self.data, 1, self.len)
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
    vec:uniquify()
    print(vec)
    print(vec:tostring())

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
