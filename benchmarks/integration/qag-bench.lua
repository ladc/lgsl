local integ = require("lgsl.integ")
local q = integ.prepare({method='qag', limit=1000, order=21})

local sin, cos, pi = math.sin, math.cos, math.pi
local epsabs, epsrel = 1e-6, 0.0001

local function bessel_gen(n)
   local xs
   local fint = function(t) return cos(n*t - xs*sin(t)) end
   return function(x)
	     xs = x
	     return q(fint, 0, pi, epsabs, epsrel)
	  end
end

local J12 = bessel_gen(12)

-- p = graph.fxplot(J12, 0, 30*pi)

local xold, xsmp = -100, 10
for k = 1, 4096*8 do
   local x = (k-1) * 30 * math.pi / (4096*8)
   local y = J12(x);
   if x - xold > xsmp then
      io.write(string.format("%.18f %.18f\n",x, y))
      xold = x
   end
end
