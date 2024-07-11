local g = require("rmis_global")

local Queue = require("_rmis_class_queue_local")

Queue.static.__apis__ = {
    "size",
    "empty",
    "enqueue",
    "dequeue",
    "front"
}

function Queue:initialize()
    Queue.super.initialize(self)
end

function Queue:size()
    return Queue.super.size(self)
end

function Queue:empty()
    return Queue.super.empty(self)
end

function Queue:enqueue(e)
    self:insert_as_last(e) -- 入队，尾部插入
end

function Queue:dequeue()
    return self:remove(self:first()) -- 出队，首部删除
end

function Queue:front()
    g.assert(self:empty() == false, "队列为空", 2)
    return self:first().data
end

function Queue:__tostring()
    return self:_tostring("<", "<")
end

if debug.getinfo(3) == nil then
    local queue = Queue()
    print(queue)
    queue:enqueue(1)
    queue:enqueue(2)
    queue:enqueue(3)
    queue:enqueue(4)
    print(queue)
    queue:dequeue()
    print(queue)
    print(queue:front())
    print(queue)
end

return Queue
