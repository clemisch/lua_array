numlua = require('numlua')

t = {}
for i = 1, 12 do t[i] = i end

a = numlua.Array()
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
