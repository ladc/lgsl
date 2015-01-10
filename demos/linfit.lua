local graph = require("graph")
local matrix = require("lgsl.matrix")
local rng = require("lgsl.rng")
local rnd = require("lgsl.rnd")
local bspline = require("lgsl.bspline")
local linfit = require("lgsl.linfit")
local sf = require("lgsl.sf")
local iter = require("lgsl.iter")

local plot = graph.plot 
local cos,exp = math.cos,math.exp

local function demo1()
   local x0, x1, n = 0, 12.5, 32
   local a, b = 0.55, -2.4
   local xsmp = function(i) return (i-1)/(n-1) * x1 end

   local r = rng.new()
   local x = matrix.new(n, 1, xsmp)
   local y = matrix.new(n, 1, function(i) return a*xsmp(i) + b + rnd.gaussian(r, 0.4) end)

   local X = matrix.new(n, 2, function(i,j) return j==1 and 1 or xsmp(i) end)
   local c, chisq, cov = linfit(X, y)
   local fit = function(x) return c[1]+c[2]*x end

   local p = graph.fxplot(fit, x0, x1)
   p:add(graph.xyline(x, y), 'blue', {{'stroke'}, {'marker', size=5}})
   p.title = 'Linear Fit'
   p.clip = false
   
   return p

 end

local function demo2()
   local order, x0, x1, n = 3, 0.0, 24.0, 96
   local bess = function(x) return sf.besselJ(order, x) end
   local xsmp = function(i) return x0 + (i-1)/(n-1) * (x1 - x0) end

   local x = matrix.new(n, 1, xsmp)
   local y = matrix.new(n, 1, function(i) return sf.besselJ(order, xsmp(i)) end)

   local xnorm = function(x) return (2*x - x0 - x1) / (x1-x0) end

   local model = function(k, x) return sf.legendreP(k, xnorm(x)) end

   local legmodel_order = 18

   local X = matrix.new(n, legmodel_order+1, function(i,j) return model(j-1, xsmp(i)) end)

   local c, chisq = linfit(X, y)
   
   local pc = graph.fibars(function(i) return c[i] end, 1, #c)
   pc.title = 'Legendre polynomials fit coefficients'
   pc.pad = true

   local fitleg = function(x)
		     return iter.isum(function(k) return c[k+1] * model(k, x) end, 0, legmodel_order)
		  end

   local p = graph.fxplot(fitleg, x0, x1)
   p:addline(graph.xyline(x, y), 'blue', {{'marker', size=5}})
   p.title = 'Legendre polynomial fit of Bessel J3(x)'
   p.clip = false
   
   return p
end
-- demo1()
-- demo2()

return {'Linear Fit', {
  {
     name= 'linfit1',
     f = demo1,
     description = 'Simple linear regression example'
  },
  {
     name= 'linfit2',
     f = demo2,
     description = 'Complex example of a linear fit based on legendre polynomials'
  },
}}
