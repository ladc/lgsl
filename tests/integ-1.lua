local lgsl = require("lgsl")
local sin, pi = math.sin, math.pi
print(string.format("%.8g", lgsl.integ(sin, 0, pi)))
print(string.format("%.8g", lgsl.integ(sin, 0, pi/2)))
print(string.format("%.8g", 0.1 + lgsl.integ(sin, 0, 2*pi)))

