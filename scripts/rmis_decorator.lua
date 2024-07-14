local g = require("rmis_global")
local pystr = require("rmis_python_str")
local decorator = {}

function decorator.cache(func)
    local cache = {}
    -- 缓存应该也要用缓存期的吧？
    local function wrap(...)
        local key = pystr.join(";", g.map(tostring, { ... }))
        if not cache[key] then
            cache[key] = setmetatable({ func(...) }, { __tostring = g.list_tostring })
        end
        return unpack(cache[key], 1, table.maxn(cache[key]))
    end
    return wrap
end

--- 该装饰器修饰后，增加了返回值，返回值的第一个值是执行的时间，有小数点的
function decorator.clock(func)
    local function wrap(...)
        local time_s = os.clock()
        local res = { func(...) }
        return os.clock() - time_s, unpack(res, 1, table.maxn(res))
    end
    return wrap
end

if debug.getinfo(3) == nil then
    local function test_fibonacci()
        return decorator.clock(function()
            local function fibonacci(n)
                return n < 2 and n or (fibonacci(n - 1) + fibonacci(n - 2))
            end
            -- 不设置缓存的话，n=40，耗时 15.304 秒。设置之后，耗时 0.01 秒
            -- fibonacci 时间复杂度为 O(2^n)，太恐怖，在实际环境中毫无价值
            -- 真的超级快，递归的斐波那契数列重复分支过多，缓存之后，n=5000 都能一瞬间得出结果
            fibonacci = decorator.cache(fibonacci)
            print(fibonacci(5000))
        end)()
    end

    print(test_fibonacci())
end

return decorator