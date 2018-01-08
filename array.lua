local Class = require('class')
local deepcopy = require('deepcopy')

local Array = Class.new()
function Array:init()
    self._data = {}         
    self._strides = {}      
    self._startOffsets = setmetatable({}, {__index = function() return 0 end})  -- positive number     
    self._stopOffsets = setmetatable({}, {__index = function() return 0 end})   -- positive number

    -- XXX: generate self.shape somewhere

end

function Array:_getShape()
    -- compute shape from strides and offsets

    local outShape = {}
    local remainingLen = #self._data

    for i, stride in ipairs(self._strides) do
        local startOffset = self._startOffsets[i] * stride
        local stopOffset = self._stopOffsets[i] * stride
        local lenAxis = (remainingLen / stride) - startOffset - stopOffset
        table.insert(outShape, lenAxis)
        remainingLen = remainingLen / lenAxis
    end
    return outShape
end

function Array:ndim()
    return #self._strides
end

function Array:_getByPositiveIndex(...)
    -- get single data point by ṕositive index
    
    local indices = {...}
    if #indices ~= self:ndim() then
        error("Number of indices must match number of dimensions")
    end



    for i, index in ipairs(indices) do
         
    end

    local totIndex = 0
    for i, index in ipairs(indices) do
        totIndex = totIndex + self._strides[i] * (self._startOffsets + index)
    end

end


function Array:reshape(...)
    local newShape = {...}

end




-- functions to generate arrays
function toArray(t)
end

function zeros(...)
end

function ones(...)
end

function range(start, stop, step)
end

function linspace(start, stop, numSteps, endpoint)
end


-------------
-- TESTING --
-------------

t = {}
for i = 1, 12 do t[i] = i end

a = Array()
a._data = t
a._strides[1] = 6
a._strides[2] = 2

shape = a:_getShape()
print(unpack(shape))
print(a:ndim())