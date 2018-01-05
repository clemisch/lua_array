local Array = require('array')

local function printTable(t)
    if type(t[1]) == 'table' then
        for _, row in ipairs(t) do
            printTable(row)
        end
    elseif type(t) == 'table' then
        print(table.concat(t, "\t"))
    else
        print(t)
    end
end

local function genTable(fillValue, ...)
    local fillValue = fillValue or 0
    local axes = {...}
    local numDim = #axes

    if numDim < 1 then
        error("Dimension < 1")
    end

    if numDim == 1 then
        local outTable = {}
        for i = 1, axes[1] do
            outTable[i] = fillValue
        end
        return outTable
    else
        local outTable = {}
        for i = 1, table.remove(axes, 1) do
            outTable[i] = genTable(fillValue, unpack(axes))
        end
        return outTable
    end
end

function genArray(fillValue, ...)
    local outArray = Array()
    outArray._data = genTable(fillValue, ...)
    outArray._shape = {...}
    return outArray
end

local function zeros(...) 
    return genTable(0, ...)
end

local function ones(...)
    return genTable(1, ...)
end



-- expose table containing functions
return {
    printTable = printTable,
    genTable = genTable,
    genArray = genArray,
    zeros = zeros,
    ones = ones,
    shape = shape,
}