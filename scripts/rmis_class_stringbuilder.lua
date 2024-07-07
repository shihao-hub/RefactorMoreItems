require("debug")

local class = require("rmis_middleclass")

local StringBuilder = class("StringBuilder") -- Java 的 StringBuilder

function StringBuilder:initialize(capacity_or_str)
    self.count = 0
    self.data = {}
    if type(capacity_or_str) == "number" then

    elseif type(capacity_or_str) == "string" then
        for i = 1, #capacity_or_str do
            self.data[i] = string.sub(capacity_or_str, i, i)
        end
        self.count = self.count + #capacity_or_str
    end


end

function StringBuilder:append(str)
    for i = 1, #str do
        self.data[self.count + i] = string.sub(str, i, i)
    end
    self.count = self.count + #str
    return self
end

function StringBuilder:__tostring()
    return table.concat(self.data)
end

-- 等价于 Python 的 if __name__ == "__main__":
if debug.getinfo(3) == nil then
    local sb = StringBuilder("abc")
    print(sb)
    sb:append("abc")
    print(sb)
end

return StringBuilder