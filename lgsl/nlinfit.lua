-- nlinfit.lua
--
-- Nonlinear least squares fitting function.
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
local NLINFIT_METHODS = {
   set     = function(ss, fdf, x0) return ss.lm.set(fdf, x0) end,
   iterate = function(ss) return ss.lm.iterate() end,
   test    = function(ss, epsabs, epsrel) return ss.lm.test(epsabs, epsrel) end,
}

local NLINFIT = {
   __index = function(t, k)
      if k == 'chisq' then
         return t.lm.chisq()
      else
         return NLINFIT_METHODS[k] or t.lm[k]
      end
   end
}

local function nlinfit(spec)
   if not spec.n then error 'number of points "n" not specified' end
   if not spec.p then error 'number of parameters "p" not specified' end

   if spec.n <= 0 or spec.p <= 0 then 
      error '"n" and "p" shoud be positive integers'
   end

   local n, p = spec.n, spec.p
   local s = { lm = template.load('lgsl.templates.lmfit', {N= n, P= p}) }

   setmetatable(s, NLINFIT)

   return s
end

return setmetatable({nlinfit=nlinfit}, {__call= function(t,...) return nlinfit(...) end})
