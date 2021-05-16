local LinkedList = require "init"

dumptbl = function(tbl, indent, cb)
    if not indent then indent = 0 end
    if not cb then cb = print end
    if indent > 6 then
        cb(string.rep("  ", indent) .. "...")
        return
    end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            cb(formatting)
            dumptbl(v, indent+1, cb)
        elseif type(v) == 'boolean' then
            cb(formatting .. tostring(v))
        elseif type(v) == "function" then
            cb(formatting .. "()")
        else
            cb(formatting .. v)
        end
    end
end


local t = LinkedList.new({
    "i'm gone",
    "hahaha",
    34,
    {e=3},
    5.4
})

t:push_back(6.6)
assert(t:back() == 6.6)
assert(t:get(t.size) == 6.6)

t:pop_back()
assert(t:back() ~= 6.6)
assert(t:get(t.size) ~= 6.6)

t:push_front(7.7)
assert(t:front() == 7.7)
assert(t:get(1) == 7.7)

t:pop_front()
assert(t:front() ~= 7.7)
assert(t:get(1) ~= 7.7)

assert(t:pop_front() == "i'm gone")

t:insert_after(1, ":Oo")
assert(t:get(2) == ":Oo")

t:insert_after(t.size, ":u")
assert(t:get(t.size) == ":u")
assert(t:back() == ":u")

dumptbl(t:to_list())
assert(#t:to_list() == #t:to_reversed_list())

do
    local l = t:to_list()
    for i, v in t:ipairs() do
        assert(v == l[i])
    end
end

