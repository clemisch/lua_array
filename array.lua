
function printArray(arr)
    if type(arr[1]) == 'table' then
        for _, row in ipairs(arr) do
            printArray(row)
        end
    elseif type(arr) == 'table' then
        print(table.concat(arr, "\t"))
    else
        print(arr)
    end
end

function genArray(fillValue, ...)
    local fillValue = fillValue or 0
    local axes = {...}
    local numDim = #axes

    if numDim == 0 then
        return fillValue

    elseif numDim == 1 then
        local outTable = {}
        for i = 1, axes[1] do
            outTable[i] = fillValue
        end
        return outTable
    else
        local outTable = {}
        for i = 1, table.remove(axes, 1) do
            outTable[i] = genArray(fillValue, unpack(axes))
        end
        return outTable
    end
end

function shape(arr)

end

a = genArray(5, 3, 2, 2)
printArray(a)
