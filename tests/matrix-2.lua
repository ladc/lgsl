local matrix = require("lgsl.matrix")

local m = matrix.new(8, 8, function(i,j) return i * j end)
print("dim", m:dim())
print(m)
