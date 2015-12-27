-- ode.lua
--
-- Functions for solving ordinary differential equation (ODE) initial value
-- problems.
-- 
-- Copyright (C) 2009-2015 Francesco Abbate
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


local template = require("lgsl.template")

local function ode(spec)
   local required = {N= 'number', eps_abs= 'number'}
   local defaults = {eps_rel = 0, a_y = 1, a_dydt = 0}
   local is_known = {rkf45= true, rk8pd= true}

   for k, tp in pairs(required) do
      if type(spec[k]) ~= tp then
         error(string.format('parameter %s should be a %s', k, tp))
      end
   end
   for k, v in pairs(defaults) do
      if not spec[k] then spec[k] = v end
   end

   local method = spec.method and spec.method or 'rkf45'
   if not is_known[method] then error('unknown ode method: ' .. method) end
   spec.method = nil

   local ode_loaded = template.load("lgsl.templates."..method, spec)

   local mt = {
      __index = {step = ode_loaded.step, init = ode_loaded.init, evolve = ode_loaded.evolve}
   }

   return setmetatable(ode_loaded.new(), mt)
end

return setmetatable({ode=ode}, {__call= function(t,...) return ode(...) end})
