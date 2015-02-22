-- multiroots.lua
--
-- Copyright (C) 2015 Lesley De Cruz
--
-- gnewton: simple globally convergent Newton method (rejects uphill steps)
--
-- This is a modified version of Newton's method which attempts to improve
-- global convergence by requiring every step to reduce the Euclidean norm of
-- the residual, |f(x)|. If the Newton step leads to an increase in the norm
-- then a reduced step of relative size,
-- t = (\sqrt(1 + 6 r) - 1) / (3 r)
-- is proposed, with r being the ratio of norms |f(x')|^2/|f(x)|^2. This
-- procedure is repeated until a suitable step size is found.
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 3 of the License, or (at
-- your option) any later version.
--
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
--
-- Adapted from GSL, version 1.16

local matrix = require("lgsl.matrix")
local GSL_DBL_EPSILON = 2.2204460492503131e-16
local sqrt = math.sqrt
local function gnewton_getstate(f,df,x0)
  return { phi = f(x0):norm(), x = x0, f = f, df = df, iter = 0 }
end

-- Run a single iteration of the globally convergent Newton method.
local function gnewton_iterate(state, f, df, x0)
  -- Solve A.x = b where A = J, b = f, x = d (J.d = f) (in fact d = -dx hence the minus signs later on)
  local f0, J0  = f(x0), df(x0)
  local d = matrix.solve(J0,f0)
  local t = 1 -- scale parameter
  -- Phi is the norm / squared distance to root of the last solution
  local phi0, phi1 = state.phi
  local x1, f1
  repeat
    x1 = x0 - t*d
    f1 = f(x1)
    phi1 = f1:norm()
    if phi1 > phi0 and t > GSL_DBL_EPSILON then
      local theta = phi1 / phi0;
      local scale_u = (sqrt(1 + 6*theta) - 1) / (3*theta);
      t = t*scale_u
    end
  until phi1 <= phi0 or t <= GSL_DBL_EPSILON -- only go downhill
  state.x = x1
  state.phi = phi1
  state.dx = -t*d
  state.iter = state.iter + 1
  return x1
end

-- Test convergence (|dx| < epsabs + |x|*epsrel)
local function gnewton_test_delta(s, epsabs, epsrel)
  epsabs = epsabs or 1e-3
  epsrel = epsrel or 0 -- if no relative error is given, only consider absolute error
  return s.dx:norm() < epsabs + epsrel*s.x:norm()
end

-- Test residual (|f| < epsabs)
local function gnewton_test_residual(s, epsabs)
  epsabs = epsabs or 1e-3
  return s.f(s.x):norm() < epsabs
end

-- Run the integrator and return the final state.
-- @param f multidimensional function (n->m)
-- @param df derivative function (n->mxn)
-- @param x0 initial conditions (n)
-- @param options table:
--        - maxiter
--        - stop_fn (function of s,epsabs,epsrel)
--        - epsabs & epsrel
--
-- @return state s with fields
--        - f: function
--        - df: derivative function
--        - converged: true if it has converged
--        - x: location of the root found
--        - dx: final step
--        - phi: norm of the residual of f(x)
--        - iter: number of iterations
--
local function gnewton_run(f, df, x0, opts, s)
  s = s or gnewton_getstate(f, df, x0)
  local maxiter = opts.maxiter or math.huge
  local stop_fn = opts.stop_fn or gnewton_test_delta
  local x = x0:copy()
  s.converged = false
  for iter = 1,maxiter do
    x = gnewton_iterate(s,f,df,x)
    if stop_fn(s, opts.epsabs, opts.epsrel) then
      s.converged = true
      break
    end
  end
  return s
end

return {
  gnewton = {
    run = gnewton_run,
    getstate = gnewton_getstate,
    test_residual = gnewton_test_residual,
    test_delta = gnewton_test_delta
  }
}
