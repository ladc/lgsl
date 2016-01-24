local matrix = require("lgsl.matrix")

print("Real scalars only. Single row.")
local mat0 = matrix.stack({{1,2,3}})
print(mat0)

print("Multi row.")
local mat1 = matrix.stack({{1,2,3},{4,5,6},{7,8,9}})
print(mat1)

print("Real and complex scalars.")
local mat2 = matrix.stack({{1i,2,3},{4,5i,6},{7,8,9i}})
print(mat2)

print("Real matrices only.")
local m1 = matrix.new(2,2)
local mat3 = matrix.stack({{m1,m1+1},{m1-1,m1}})
print(mat3)

print("Real and complex matrices.")
local m2 = matrix.cnew(2,2)+1
local mat4 = matrix.stack({{m1,m1+1i},{m1-1i,m1}})
print(mat4)

print("Real, complex matrices and scalars.")
local a1 = matrix.cnew(2,2)+1+1i
local a2 = matrix.new(2,2)+1
local a3 = 4 
local b1 = matrix.new(2,2)-1
local b2 = matrix.new(2,2)
local b3 = 5i

local mat5 = matrix.stack({{a1,a2,a3},{b1,b2,b3}})
print(mat5)
