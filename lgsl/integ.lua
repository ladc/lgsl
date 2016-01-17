-- integ.lua
--
-- integ: Function that performs a 1D numeric integration.
-- prepare: Create a function that can perform a 1D numeric integration.
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
local check = require("lgsl.check")
local q_default

local function integ(f, a, b, epsabs, epsrel)
   epsabs = epsabs or 1e-8
   epsrel = epsrel or 1e-8

   check.number(a)
   check.number(b)
   
   if not q_default then
      q_default = template.load('lgsl.templates.qag', {limit= 64, order= 21})
   end

   local result = q_default (f, a, b, epsabs, epsrel)

   return result
end

local function quad_prepare(options)
   local known_methods = {qng= true, qag= true}

   local method = options.method or 'qag'
   local order  = options.order  or 21
   local limit  = options.limit  or 64

   if not known_methods[method] then
      error('the method ' .. method .. ' is unknown')
   end

   check.integer(limit)

   if limit < 8 then limit = 8 end
   
   local q = template.load("lgsl.templates."..method, {limit= limit, order= order})

   return q
end

return {
  integ = integ,
  prepare = quad_prepare
}
