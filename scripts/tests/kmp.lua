local function brute_force_match(t, p)
    -- Lua 从 1 开始太反人类了 for i=1,n do <-> [1,n]
    local t_len, p_len = #t, #p
    for i = 1, t_len do
        local old = i
        for j = 1, p_len do
            if i > t_len then
                return -1
            end
            if string.sub(p, j, j) ~= string.sub(t, i, i) then
                break
            end
            i = i + 1
        end
        if i - old == #p then
            return old
        end
        i = old + 1
    end
    return -1
end

print(brute_force_match("12345678", "78"))
