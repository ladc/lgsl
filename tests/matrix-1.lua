local matrix = require("lgsl.matrix")
local m = matrix.new(3, 3)
print("dim", m:dim())
for i = 1, 3 do
    for j = 1, 3 do
        print(m:get(i,j))
    end
end

