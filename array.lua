local Class = require('class')
local deepcopy = require('deepcopy')

local Array = Class.new()
function Array:init()
    self._data = {}         
    self._strides = {}      
    self._startOffsets = setmetatable({}, {__index = function() return 0 end})  -- positive number     
    self._stopOffsets = setmetatable({}, {__index = function() return 0 end})   -- positive number

    -- XXX: 
    --  - generate self.shape somewhere
    --  - set ndim

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

function Array:view()
    -- return new view on data 

    local outArr = Array()

    -- view on data
    outArr._data = self._data

    -- copy metainformation
    outArr._strides = deepcopy(self._strides)
    outArr._startOffsets = deepcopy(self._startOffsets)
    outArr._stopOffsets = deepcopy(self._stopOffsets)
    outArr._owndata = false

    return outArr
end

function Array:_getByPositiveIndex(...)
    --[[
    Get single data point by ṕositive index.

    TODO: remove checks and put them in higher API method (performance)
    ]] 

    local indices = {...}
    if #indices ~= self:ndim() then
        error("Number of indices must match number of dimensions")
    end

    local shape = self:_getShape()
    for i, index in ipairs(indices) do
        if index < 1 then
            error("Provide indices > 0")
        end
        if index > shape[i] then
            error("Index " .. tostring(index) .. " too big for axis " .. tostring(i))
        end
    end

    local totIndex = 0
    for i, index in ipairs(indices) do
        -- calculate in 0-indexing 
        totIndex = totIndex + self._strides[i] * (self._startOffsets[i] + index - 1) 
    end
    -- convert to 1-indexing (kill me pls)
    totIndex = totIndex + 1

    return self._data[totIndex]
end


function Array:reshape(...)
    local newShape = {...}

end

function Array:T()
    if self:ndim() ~= 2 then
        error(":T() only works with 2D arrays")
    end

    local outArr = self:view()
    outArr._strides[1], outArr._strides[2] = outArr._strides[2], outArr._strides[1]
    outArr._startOffsets[1], outArr._startOffsets[2] = outArr._startOffsets[2], outArr._startOffsets[1]
    outArr._stopOffsets[1], outArr._stopOffsets[2] = outArr._stopOffsets[2], outArr._stopOffsets[1]

    return outArr
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
a._strides[2] = 1
b = a:view()

shape = a:_getShape()
print(unpack(shape))
print(unpack(a:T():_getShape()))
print(a:ndim())
print(a:_getByPositiveIndex(2, 1))

print()