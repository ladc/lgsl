local roots = require("lgsl.roots")
local printf = function(...) io.write(string.format(...)) end
local rand, abs = math.random, math.abs
math.randomseed(90357) -- reproducible
local newton = roots.newton

--------------------------------------------------------------------------------
-- Example 1: polynomial (scalar)
--------------------------------------------------------------------------------

-- Determine the number from the roots table nearest to x, and its index
local function getnearestroot(x, polyroots)
  local dmin, imin = math.huge
  for i,root in ipairs(polyroots) do
    local d = abs(x-root)
    if d < dmin then
      imin = i
      dmin = d
    end
  end
  return polyroots[imin], imin
end

-- Generate a random polynomial of order nroots with coefficients no larger
-- than maxval in absolute value.
local function getpoly(nroots, maxval)
  local polyroots = {}
  for i=1,nroots do
    polyroots[i] = 2 * maxval * (rand() - 0.5)
  end
  -- Polynomial
  local f = function(x)
    local result = 1
    for i=1,nroots do
      result = result * (x - polyroots[i])
    end
    return result
  end
  -- Derivative
  local df = function(x)
    local result = 0
    for i=1,nroots do
      local term = 1
      for j=1,nroots do
        if j~=i then
          term = term * (x - polyroots[j])
        end
      end
      result = result + term
    end
    return result
  end
  return f, df, polyroots
end

-- Note that if test_residual is used, epsabs should be defined >0 (epsrel is
-- meaningless since the residual is compared to zero).
local opts = {maxiter = 1000, epsabs = 1e-9, stop_fn = roots.test_residual}

-- Find roots of generated polynomials.
for i=1,20 do
  local f,df,polyroots = getpoly(5,10)
  local result = newton(f,df,0,opts)
  local exact = getnearestroot(result.x, polyroots)
  printf("polynom:    iter = %3u\tx = %.3f\t\terror = %.3e\tdx = %.3e\n",
  result.iter,result.x,result.x - exact, math.abs(result.dx))
end

