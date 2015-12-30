-- roots.lua
--
-- Copyright (C) 2015 Lesley De Cruz
--
-- newton: simple root finder, Newton method 
-- gnewton: simple globally convergent Newton method (rejects uphill steps)
--
-- This file implements both the original and a modified version of Newton's
-- method which attempts to improve global convergence by requiring every step
-- to reduce the Euclidean norm of the residual, |f(x)|. If the Newton step
-- leads to an increase in the norm then a reduced step of relative size,
-- t = (\sqrt(1 + 6 r) - 1) / (3 r)
-- is proposed, with r being the ratio of norms |f(x')|/|f(x)|. This
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
local sqrt, abs = math.sqrt, math.abs
local norm = function(x) return type(x)=="number" and abs(x) or x:norm() end

local function generic_newton_newstate(f,df,x0)
  return { phi = norm(f(x0)), x = x0, f = f, df = df, iter = 0, converged=false}
end

-- Run a single iteration of the original Newton method for 1d.
local function newton_iterate_1d(state, f, df, x0)
  local d = f(x0)/df(x0)
  local x1 = x0 - d
  state.x = x1
  state.dx = -d
  state.iter = state.iter + 1
  return x1
end

-- Run a single iteration of the original Newton method.
local function newton_iterate(state, f, df, x0)
  -- Solve A.x = b where A = J, b = f, x = d (J.d = f) (in fact d = -dx hence the minus signs later on)
  local f0, J0  = f(x0), df(x0)
  local d = matrix.solve(J0,f0)
  local x1 = x0 - d
  state.x = x1
  state.dx = -d
  state.iter = state.iter + 1
  return x1
end

-- Run a single iteration of the globally convergent Newton method for 1d.
local function gnewton_iterate_1d(state, f, df, x0)
  local d = f(x0)/df(x0)
  local t = 1 -- scale parameter
  -- Phi is the norm / distance to root of the last solution
  local phi0, phi1 = state.phi
  local x1
  repeat
    x1 = x0 - t*d
    phi1 = norm(f(x1))
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

-- Run a single iteration of the globally convergent Newton method.
local function gnewton_iterate(state, f, df, x0)
  -- Solve A.x = b where A = J, b = f, x = d (J.d = f) (in fact d = -dx hence the minus signs later on)
  local f0, J0  = f(x0), df(x0)
  local d = matrix.solve(J0,f0)
  local t = 1 -- scale parameter
  -- Phi is the norm / distance to root of the last solution
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
local function test_delta(s, epsabs, epsrel)
  epsabs = epsabs or 1e-3
  epsrel = epsrel or 0 -- if no relative error is given, only consider absolute error
  return norm(s.dx) < epsabs + epsrel*norm(s.x)
end

-- Test residual (|f| < epsabs)
local function test_residual(s, epsabs)
  epsabs = epsabs or 1e-3
  return norm(s.f(s.x)) < epsabs
end

-- Run the root finder and return the final state.
-- @param f (possibly multidimensional) function (n->m)
-- @param df derivative function (Jacobian) (n->mxn)
-- @param x0 initial conditions (n)
-- @param opts options table:
--        - maxiter
--        - stop_fn (function of s,epsabs,epsrel)
--        - epsabs & epsrel
-- @param s (optional) state from previous run
--
-- @return state s with fields
--        - f: function
--        - df: derivative function
--        - converged: true if it has converged
--        - x: location of the root found
--        - dx: final step
--        - phi: norm of the residual of f(x)
--        - iter: number of iterations

local function generic_newton_run(f, df, x0, opts, s, iterate)
  local x = type(x0)=="number" and x0 or x0:copy()
  s = s or generic_newton_newstate(f, df, x0)
  opts = opts or {}
  local maxiter = opts.maxiter or 1e4
  local stop_fn = opts.stop_fn or test_delta
  s.converged = false
  for iter = 1,maxiter do
    x = iterate(s,f,df,x)
    if stop_fn(s, opts.epsabs, opts.epsrel) then
      s.converged = true
      break
    end
  end
  return s
end

local function gnewton_run(f, df, x0, opts, s)
  local iterate = type(x0)=="number" and gnewton_iterate_1d or gnewton_iterate
  return generic_newton_run(f, df, x0, opts, s, iterate)
end

local function newton_run(f, df, x0, opts, s)
  local iterate = type(x0)=="number" and newton_iterate_1d or newton_iterate
  return generic_newton_run(f, df, x0, opts, s, iterate)
end

return {
  gnewton = gnewton_run,
  newton = newton_run,
  test_residual = test_residual,
  test_delta = test_delta,
}
