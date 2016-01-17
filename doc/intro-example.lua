
local vegas = require("lgsl.vegas")
local sf = require("lgsl.sf") -- for the analytical solution, see below
local iter = require("lgsl.iter") -- for defining the integration boundaries

local function getunitsphere(n)
   return function(x)
      local s = 0
      for k= 1, n do s = s + x[k]^2 end
      return s < 1 and 1 or 0
   end
end

local graph = require("graph")
local ln = graph.path(1, 2) -- 1-sphere = [-1, 1] (length 2)
local max_dim = 14

--Calculating the volume of d-dimensional sphere
for d=2, max_dim do
   --Intializing work varaibles
   local a = iter.ilist(function() return 0 end, d)
   local b = iter.ilist(function() return 1 end, d)
   local calls, n = d*1e4,1

   --Obtaining monte carlo vegas callback
   local s = vegas.integ(getunitsphere(d),a,b,calls)
   local fmt = "Volume = %.3f +/- %.3f "
   print(string.format(fmt,s.result*2^d,s.sigma*2^d))

   --Increasing the number of calls to reach a satisfying result
   while(s.sigma/s.result > 0.005) do
      print("Increasing accuracy, doubling number of calls...")
      s = s.continue(calls*(2^n))
      print(string.format(fmt,s.result*2^d,s.sigma*2^d))
      n=n+1
   end
   ln:line_to(d,s.result*2^d)
end

--plotting a comparison of the numerical result with the analytical solution
local p = graph.plot('Volume of a unit n-sphere')
p.clip, p.pad = false, true
local analytic = function(n) 
  return math.pi^(n/2) / sf.gamma(1+n/2)
end
p:addline(graph.fxline(analytic, 1, max_dim))
p:add(ln, "blue", {{'marker', size=8}})
p.xtitle="n"
p.ytitle="V"
p:show()
