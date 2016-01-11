local integ = require("lgsl.integ")
local sin, pi = math.sin, math.pi
print(string.format("%.8g", integ.integ(sin, 0, pi)))
print(string.format("%.8g", integ.integ(sin, 0, pi/2)))
print(string.format("%.8g", 0.1 + integ.integ(sin, 0, 2*pi)))

