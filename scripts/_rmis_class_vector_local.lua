local g = require("rmis_global")
local class = require("rmis_middleclass")

---@class Vector
local Vector = class("Vector")

function Vector:_move_elements()

end

--- 备注：check 检查的东西应该和 assert 统一，为真的时候，就通过。否则，才报错。
function Vector:_check_non_nil_value(v, msg)
    msg = msg or g.f("不允许为空值")
    if v == nil then
        error(msg, 2)
    end
end

function Vector:_check_valid_rank_value(r, msg, left, right)
    msg = msg or g.f("秩超出范围了，合法范围为：[{{l}}, {{r}}]", { l = left, r = right })
    left = left or 1
    right = right or self.len
    if not (r >= left and r <= right) then
        error(msg, 2)
    end
end

--- 收缩一下区间，不用的内容设置为 nil，方便 Lua 自己找机会收缩
function Vector:_shrink_the_interval(left, right)
    for i in g.range(left, right) do
        self.data[i] = nil
    end
    self.len = left - 1
end

return Vector
