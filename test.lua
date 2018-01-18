local Array = require("array_2d")

function range(start, stop, step)
    local step = step or 1
    local dataTable = {}
    for i = start, stop, step do
        table.insert(dataTable, {i})
    end
    local outArr = Array(#dataTable, 1)
    outArr._data = dataTable

    return outArr
end

a = range(1, 25):reshape(5, 5)
print(a)
a:slice(2, 4, 1, 2, 4, 1)
