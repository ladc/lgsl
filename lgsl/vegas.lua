-- vegas.lua
-- 
-- Create a function that can perform a VEGAS Monte Carlo multidimensional
-- numerical integration.
--
-- Copyright (C) 2009-2015 Lesley De Cruz & Francesco Abbate
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


local ffi = require("ffi")
local template = require("lgsl.template")

local abs  = math.abs

local default_spec = {
   K = 50, -- max bins: even integer, will be divided by two
   SIZE_OF_INT = ffi.sizeof('int'),
   SIZE_OF_DOUBLE = ffi.sizeof('double'),
   MODE_IMPORTANCE = 1,
   MODE_IMPORTANCE_ONLY = 2,
   MODE_STRATIFIED = 3,
   ALPHA = 1.5,
   MODE = 1,
   ITERATIONS = 5,
}

local function getintegrator(state,template_spec)
  --- perform VEGAS Monte Carlo integration of f
  -- @param f function of an N-dimensional vector (/table/ffi-array...)
  -- @param a lower bound vector (1-based indexing)
  -- @param b upper bound vector (1-based indexing)
  -- @param calls number of function calls (will be rounded down to fit grid)
  -- @param options table of parameters (optional), of which:
  --   r random number generator (default random)
  --   chidev deviation tolerance for the integrals' chi^2 value
  --         integration will be repeated until chi^2 < chidev
  --   warmup number of calls for warmup phase (default 1e4)
  return function(f,a,b,calls,options)
    local r = options and options.r
    local rget = r and (function() return r:get() end) or math.random
    local chidev = options and options.chidev or 0.5
    local N = template_spec.N
    calls = calls or 1e4*N
    local a_work = a
    if type(a)=="table" then
      a_work = ffi.new("double[?]",N+1)
      for i=1,N do a_work[i] = a[i] end
    end
    state.init(a_work, b) -- initialise
    state.clear_stage1() -- clear results
    state.rebin_stage2(options and options.warmup or 1e4) -- intialise grid
    state.integrate(f,a_work,rget) -- warmup
    local result_state = {}
    -- full integration:
    local function cont(c)
      calls = c or calls
      result_state.nruns = 0
      repeat
        -- forget previous results, but not the grid
        state.clear_stage1()
        -- rebin grid for (modified) number of calls
        state.rebin_stage2(calls/template_spec.ITERATIONS)
        result_state.result,result_state.sigma = state.integrate(f,a_work,rget)
        result_state.nruns = result_state.nruns+1
      until abs(state.chisq() - 1) < chidev
      return result_state 
    end
    result_state.continue = cont
    cont(calls)
    return result_state
  end
end

--- prepare a VEGAS Monte Carlo integrator
-- @param spec Table with variables that are passed to the template:
--   N number of dimensions of the function
--      e.g. useful if a,b are ffi arrays
--   (Don't change the following variables unless you know what you're doing:)
--   K max. number of bins, even integer (will be divided by two)
--   ALPHA grid flexibility
--   MODE 1: importance, 2: importance only, 3: stratified
--   ITERATIONS number of integrations used for consistency check;
--      each integration uses (calls/iterations) function calls
-- @return vegas_integ integrator
local function vegas_prepare(spec)
  -- read template specs
  local template_spec = {N = spec.N}
  for k,v in pairs(default_spec) do
    template_spec[k] = spec[k] or v
  end
  -- initialise vegas states
  local state = template.load('lgsl.templates.vegas-defs', template_spec)
  return getintegrator(state,template_spec)
end
  
--- perform VEGAS Monte Carlo integration of f with default specs; determine N
-- from bound vector.
-- @param f function of an N-dimensional vector (/table/ffi-array...)
-- @param a lower bound vector (1-based indexing)
-- @param b upper bound vector (1-based indexing)
-- @param calls number of function calls (will be rounded down to fit grid)
-- @param options table of parameters (optional), of which:
--   r random number generator (default random)
--   chidev deviation tolerance for the integrals' chi^2 value
--         integration will be repeated until chi^2 < chidev
--   warmup number of calls for warmup phase (default 1e4)
local function vegas_integ(f,a,b,calls,options)
  local integrator = vegas_prepare({N=#a})
  return integrator(f,a,b,calls,options)
end

return {
  prepare = vegas_prepare,
  integ = vegas_integ,
}
