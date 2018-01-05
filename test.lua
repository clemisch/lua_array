Array = require('array')
functions = require('functions')

a = functions.zeros(3, 3)
functions.printTable(a.data)
s = a:getShapeFromDataTable()
functions.printTable(s)