local Class = require('class')
local deepcopy = require('deepcopy')

local function _genDataTable(fillValue, ...)
    local fillValue = fillValue or 0
    local axes = {...}
    local numDim = #axes

    if numDim < 1 then
        error("Dimension < 1")
    end

    if numDim == 1 then
        for i = 1, axes[1] do
            local outTable = {}
            outTable[i] = fillValue
        end
        return outTable

    else
        local outTable = {}
        print(unpack(axes))
        for i = 1, table.remove(axes, 1) do
            outTable[i] = _genDataTable(fillValue, unpack(axes))
        end
        return outTable
    end
end


local Array = Class.new()
function Array:init(...)
    local shape = {...}
    self._shape = shape
    self._data = _genDataTable(0, unpack(shape))
end


function Array:slice(...)

end

function Array:getShapeFromDataTable()
    local shape = {}
    shape[1] = #self._data
    local viewInto = self._data[1]
    while type(viewInto) == 'table' do
        table.insert(shape, #viewInto)
        viewInto = viewInto[1]
    end
    return shape
end

function Array:getShape()
    return deepcopy(self._shape)
end

return Array
