-- some 'functional' functions on tables

local function map(func, t)
    local newTable = {}
    for i, val in ipairs(t) do
        newTable[i] = func(val)
    end
    return newTable
end

local function reduce(func, t)
    local outVal = t[1]
    for i = 2, #t do
        outVal = func(outVal, t[i])
    end
    return outVal
end

t = {}
for i = 1, 36 do
    t[i] = i
end

s = reduce(function (a, b) return a + b end, t)
print(s)
