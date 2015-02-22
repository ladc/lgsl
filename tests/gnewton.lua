local sqrt = math.sqrt
local m = require("lgsl.matrix")
local multiroots = require("lgsl.multiroots")
local printf = function(...) io.write(string.format(...)) end

local gnewton = multiroots.gnewton

--------------------------------------------------------------------------------
-- Example 1: sqrt(5)
--------------------------------------------------------------------------------

local opts = {maxiter = 100, epsabs = 0, epsrel = 1e-3}

local function f5(x)
  return m.vec{x[1]^2 - 5}
end

local function df5(x) 
  return m.vec{2*x[1]}
end

local xini = m.vec{5.0}

-- Run root finder
local res = gnewton.run(f5,df5,xini,opts)

printf(
  "sqrt(5):    iter = %3u\tx = %.3f\t\terror = %.3e\testimated error = %.3e\n",
  res.iter,res.x[1],res.x[1] - sqrt(5), res.dx:norm())

--------------------------------------------------------------------------------
-- Example 2: Rosenbrock
--------------------------------------------------------------------------------

local a,b = 1,10 -- fn parameters
opts = {maxiter = 1000, epsabs = 1e-7, stop_fn = gnewton.test_residual}

local function fR(x)
  return m.vec{ a* (1 - x[1]),b*(x[2] - x[1]^2)}
end

local function dfR(x)
  return m.def{{       -a, 0},
               {-2*b*x[1], b}}
end

xini = m.vec{-10,-5}

-- Run root finder
res = gnewton.run(fR,dfR,xini,opts)

local x = res.x
printf(
  "rosenbrock: iter = %3u\tx = (%.3f,%.3f)\tf(x) = (%.3e,%.3e)\t  error = %.3e\n",
  res.iter,x[1],x[2],res.f(x)[1],res.f(x)[2],res.phi)
