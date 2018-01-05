local Class = require('class')
local deepcopy = require('deepcopy')

local Array = Class.new()
function Array:init()
    self._data = {}          -- table to store actual data
    self._shape = {}         -- shape of the data table
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

function Array:shape() 
    return deepcopy(self.shape)
end

return Array