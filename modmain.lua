---
--- Created by zsh.
--- DateTime: 2024/7/7 17:42
---

GLOBAL.setmetatable(env, { __index = function(_, k)
    return GLOBAL.rawget(GLOBAL, k)
end })