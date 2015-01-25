local matrix = require("lgsl.matrix")

local function n2str(x)
    return string.format("%.8g", x)
end

local m = matrix.new(8, 8, function(i,j) return i * j end)
print("dim", m:dim())
for i = 1, 8 do
    local t = {}
    for j = 1, 8 do
        t[j] = n2str(m:get(i,j))
    end
    print(table.concat(t, " "))
end

