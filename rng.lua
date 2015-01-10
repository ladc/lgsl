-- rng.lua
--
-- Pseudorandom number generators.
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

local gsl = require("lgsl.gsl")
local ffi = require("ffi")

local format, tonumber = string.format, tonumber

local rng =  {}

local rng_type = ffi.typeof('gsl_rng')

local function rng_getint(r, seed)
   return tonumber(gsl.gsl_rng_uniform_int(r, seed))
end

local rng_mt = {
   __tostring = function(s)
                   return format("<random number generator: %p>", s)
                end,

   __index = {
      getint = rng_getint,
      get    = gsl.gsl_rng_uniform,
      set    = gsl.gsl_rng_set,
   },
}

ffi.metatype(rng_type, rng_mt)

local function rng_type_lookup(s)
   if s then
      local ts = gsl.gsl_rng_types_setup()
      while ts[0] ~= nil do
         local t = ts[0]
         if ffi.string(t.name) == s then
            return t
         end
         ts = ts+1
      end
      error('unknown generator type: ' .. s)
   else
      return gsl.gsl_rng_default
   end
end

function rng.new(s)
   local T = rng_type_lookup(s)
   return ffi.gc(gsl.gsl_rng_alloc(T), gsl.gsl_rng_free)
end

function rng.list()
   local t = {}
   local ts = gsl.gsl_rng_types_setup()
   while ts[0] ~= nil do
      t[#t+1] = ffi.string(ts[0].name)
      ts = ts+1
   end
   return t
end

return rng
