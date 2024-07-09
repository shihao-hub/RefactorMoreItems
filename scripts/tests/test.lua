local g = require("rmis_global")
local str = require("rmis_string")



--print(str.format("%s %s %d",nil,{}))

--print(debug.getinfo(1).short_src)
--print(debug.getinfo(2).short_src)
require("rmis_class_stringbuilder")

print(string.match("word|word|word","(%w+)()(|)()"))


print(string.find("self.len+1","([ ()-A-Za-z0-9_]+)"))

print(string.find("   self.len + 1 ","^ *(.-) *$"))
