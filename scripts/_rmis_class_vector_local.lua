local g = require("rmis_global")
local class = require("rmis_middleclass")
local Object = require("rmis_class_object")

---@class Vector : Object
local Vector = class("Vector", Object)

function Vector:_move_elements()

end

--- 备注：check 检查的东西应该和 assert 统一，为真的时候，就通过。否则，才报错。
function Vector:_check_non_nil_value(v, msg)
    msg = msg or g.f("不允许为空值")
    if v == nil then
        error(msg, 2)
    end
end

--- [)
---@overload fun(left:number,right:number)
function Vector:_check_valid_rank_value(r, msg, left, right)
    if not msg and not left and not right then
        left = 1
        right = self._size
    elseif msg and left and not right then
        right = left
        left = msg
    end
    msg = g.f("秩超出范围了，合法范围为：[{{l}}, {{r}})", { l = left, r = right })
    if not (r >= left and r < right) then
        error(msg, 2)
    end
end

--- 收缩一下区间，不用的内容设置为 nil，方便 Lua 自己找时间清理掉
function Vector:_shrink_the_interval(left, right)
    for i in g.range(left, right) do
        self.data[i] = nil
    end
    self._size = left - 1
end

function Vector:_tostring(left_char, right_char)

end

function Vector:_insertion_sort(start_pos,end_pos)

end

return Vector
