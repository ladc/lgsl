local iter = require("lgsl.iter")

local vegas = require("lgsl.vegas")
local ilist = iter.ilist

local graph = require("graph")
local sf = require("lgsl.sf")

local function testdim(n)
  local lo,hi = 0,2
  local exact =  n*(n+1)/2 * (hi^3 - lo^3)/3 * (hi-lo)^(n-1)
  local function integrand(x)
     local s = 0
     for k= 1, n do s = s + k*x[k]^2 end
     return s
  end
  local a, b = ilist(function() return lo end, n), ilist(function() return hi end, n)
  print("Integrating SUM_(k=1,"..n..") k*x[k]^2")
  local calls = 1e4*n
  local vegas_result = vegas.integ(integrand,a,b,calls)
  print( string.format([[
result = %.6f
sigma  = %.6f
exact  = %.6f
error  = %.6f = %.2g sigma
calls  = %.0f
==========================
]] ,vegas_result.result,vegas_result.sigma,exact, 
    vegas_result.result - exact,
    math.abs(vegas_result.result - exact)/vegas_result.sigma,vegas_result.nruns*calls))
  return vegas_result.result
end

local function demo1()
  local maxdim = 10
  local lo,hi = 0,2
  local results = {}
  local p = graph.plot('Integral of sum (i*x_i^2) (i=1..n)')
  p.clip, p.pad = false, true
  local exact = graph.filine(function(n) return n*(n+1)/2 * (hi^3 - lo^3)/3 * (hi-lo)^(n-1) end,maxdim)
  local computed = graph.filine(testdim,1,maxdim)
  p:addline(exact)
  p:add(computed, "blue", {{'marker', size=8}})
  p.xtitle="n"
  p:show()
end

local function getunitsphere(n)
   return function(x)
	     local s = 0
	     for k= 1, n do s = s + x[k]^2 end
	     return s < 1 and 1 or 0
	  end
end

local function demo2()
  local ln = graph.path(1, 2) -- 1-sphere = [-1, 1] (length 2)
  local max_dim = 14
  for d=2, max_dim do
    print("==========================================")
    print("Calculating the volume of a unit "..d.."-sphere.")
    local a, b = ilist(function() return 0 end, d), ilist(function() return 1 end, d)
    local calls, n = d*1e4,1
    local vegas_result = vegas.integ(getunitsphere(d),a,b,calls)
    local res,sig,num,cont = vegas_result.result, vegas_result.sigma, vegas_result.nruns, vegas_result.continue
    local fmt = "Volume = %.3f +/- %.3f "
    print(string.format(fmt,res*2^d,sig*2^d))
    while(sig/res > 0.005) do
      print("Increasing accuracy, doubling number of calls...")
      vegas_result = cont(calls*(2^n))
      res,sig,num = vegas_result.result, vegas_result.sigma, vegas_result.nruns
      print(string.format(fmt,res*2^d,sig*2^d))
      n=n+1
    end
    ln:line_to(d,res*2^d)
  end
  local p = graph.plot('Volume of a unit n-sphere')
  p.clip, p.pad = false, true
  p:addline(graph.fxline(function(n) return math.pi^(n/2) / sf.gamma(1+n/2) end, 1, max_dim))
  p:legend('exact value', 'red', 'line')
  p:addline(ln, "blue", {{'marker', size=6}})
  p:legend('calculated', 'blue', 'circle', {{'stroke'}})
  p.xtitle="n"
  p.ytitle="V"
  p:show()
end

return {'VEGAS Monte Carlo integration', {
  {
     name= 'vegas',
     f = demo1,
     description = 'Integrate 9 n-dimensional functions sum(i*(x_i^2))'
  },
  {
     name= 'sphere',
     f = demo2,
     description = 'Calculate the volume of a unit n-sphere (n=2..14)'
  }
}}
