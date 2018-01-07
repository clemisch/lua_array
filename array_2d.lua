local Class = require("class")
local deepcopy = require("deepcopy")

local Array2D = Class.new()
function Array2D:init(rows, cols, val)
    local val = val or 0
    self.rows = rows
    self.cols = cols

    self._data = {}
    for i = 1, self.rows do
        local tempRow = {}
        for j = 1, self.cols do
            tempRow[j] = val
        end
        self._data[i] = tempRow
    end
end

function Array2D:setValue(val)
    for i = 1, self.rows do
        for j = 1, self.cols do
            self._data[i][j] = val
        end
    end
end

function Array2D:copy()
    local arrayCopy = Array2D(self.rows, self.cols)
    arrayCopy._data = deepcopy(self._data)
    return arrayCopy
end

function Array2D:add(val)
    -- scalar or element-wise addition

    local outArr = Array2D(self.rows, self.cols)

    if type(val) == "number" then
        for i = 1, self.rows do
            for j = 1, self.cols do
                outArr._data[i][j] = self._data[i][j] + val
            end
        end

    else
        if self.rows ~= val.rows then
            error("Number of rows dont match")
        end

        if self.cols ~= val.cols then
            error("Number of columns dont match")
        end

        for i = 1, self.rows do
            for j = 1, self.cols do
                outArr._data[i][j] = self._data[i][j] + val._data[i][j]
            end
        end
    end

    return outArr
end

function Array2D:mult(val)
    -- scalar or element-wise multiplication

    local outArr = Array2D(self.rows, self.cols)

    if type(val) == "number" then
        for i = 1, self.rows do
            for j = 1, self.cols do
                outArr._data[i][j] = self._data[i][j] * val
            end
        end

    else
        if self.rows ~= val.rows then
            error("Number of rows dont match")
        end

        if self.cols ~= val.cols then
            error("Number of columns dont match")
        end

        for i = 1, self.rows do
            for j = 1, self.cols do
                outArr._data[i][j] = self._data[i][j] * val._data[i][j]
            end
        end
    end

    return outArr
end

function Array2D:dot(other)
    -- matrix multiplication

    if self.cols ~= other.rows then
        error("First's columns dont match second's rows")
    end

    local newArr = Array2D(self.rows, other.cols, 0)

    for i_row = 1, self.rows do
        for i_col = 1, other.cols do
            for ii = 1, self.cols do
                newArr._data[i_row][i_col] = newArr._data[i_row][i_col] +
                    self._data[i_row][ii] * other._data[ii][i_col]
            end
        end
    end

    return newArr
end

function Array2D:T()
    local newArr = Array2D(self.cols, self.rows)
    for i = 1, self.rows do
        for j = 1, self.cols do
            newArr._data[j][i] = self._data[i][j]
        end
    end
    return newArr
end

function Array2D:flatten()
    local size = self.rows * self.cols
    local newArr = Array2D(size, 1)

    for i = 1, self.rows do
        for j = 1, self.cols do
            newArr._data[(i - 1) * self.cols + j][1] = self._data[i][j]
        end
    end

    return newArr
end

function Array2D:reshape(rows, cols)
    if rows * cols ~= self.rows * self.cols then
        error("Number of elements must remain unchanged")
    end

    local outArray = Array2D(rows, cols)

    for i = 1, self.rows do
        for j = 1, self.cols do

            local flat_index = (i - 1) * self.cols + (j - 1)
            local new_i = math.floor(flat_index / cols) + 1
            local new_j = (flat_index % cols) + 1

            outArray._data[new_i][new_j] = self._data[i][j]
        end
    end

    return outArray
end

function Array2D:slice(i_start, i_end, i_step, j_start, j_end, j_step)
    local dataTable = {}

    for i = i_start, i_end, i_step do
        local newRow = {}
        for j = j_start, j_end, j_step do
            table.insert(newRow, self._data[i][j])
        end
        table.insert(dataTable, newRow)
    end

    local outArr = Array2D(#dataTable, #(dataTable[1]))
    outArr._data = dataTable

    return outArr
end









function Array2D:__tostring()
    local outString = ""
    for i, row in ipairs(self._data) do
        outString = outString .. table.concat(row, "\t") .. "\n"
    end
    return outString
end

function Array2D:__unm()
    return self:mult(-1)
end

function Array2D:__add(other)
    if type(self) == "number" then
        return other:add(self)
    else
        return self:add(other)
    end
end

return Array2D
