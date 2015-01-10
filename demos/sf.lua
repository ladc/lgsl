local graph = require("graph")
local sf = require("lgsl.sf")
local pi,sqrt,exp = math.pi,math.sqrt,math.exp
local plot,window,fxline=graph.plot,graph.window,graph.fxline
local fact, laguerre, hyperg1F1 = sf.fact, sf.laguerre, sf.hyperg1F1
local function hermiteLp(n,x)
   return 1/sqrt(fact(n) *2^n*sqrt(pi)) * exp(-x*x/2) * (-4)^(n/2) * fact(n/2) * laguerre(n/2, -1/2, x^2)
end

local function hermiteFp(n,x)
   return 1/sqrt(fact(n) *2^n*sqrt(pi)) * exp(-x*x/2) * (-1)^(n/2) * fact(n)/fact(n/2) * hyperg1F1(-n/2, 1/2, x^2)
end

local function demo_gen(hermiteFF)
   local w = window('v...')

   local p = plot('Hermite(2, x)')
   p:addline(fxline(function(x) return hermiteFF(2, x) end, -10, 10), 'red')
   w:attach(p, '1')

   p = plot('Hermite(4, x)')
   p:addline(fxline(function(x) return hermiteFF(4, x) end, -10, 10), 'blue')
   w:attach(p, '2')

   p = plot('Hermite(16, x)')
   p:addline(fxline(function(x) return hermiteFF(16, x) end, -10, 10, 512), 'green')
   w:attach(p, '3')
end

local demo1 = function() demo_gen(hermiteLp) end
local demo2 = function() demo_gen(hermiteFp) end

return {'Special Functions', {
  {
     name = 'sf1',
     f = demo1,
     description = 'Hermite function using Laguerre polynomials'
  },
  {
     name = 'sf2',
     f = demo2,
     description = 'Hermite function using Hypergeometric 1F1 function'
  },
}}
