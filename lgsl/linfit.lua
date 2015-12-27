-- linfit.lua
--
-- Linear least squares fitting function.
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

local ffi = require("ffi")
local gsl = require("lgsl.gsl")
local gsl_check = require("lgsl.gsl-check")
local matrix = require("lgsl.matrix")

local workspace
local workspace_n
local workspace_p

local function get_workspace(n, p)
   local ws
   if n == workspace_n and p == workspace_p then
      ws = workspace
   else
      ws = ffi.gc(gsl.gsl_multifit_linear_alloc(n, p),
                  gsl.gsl_multifit_linear_free)

      workspace_n = n
      workspace_p = p
      workspace   = ws
   end
   return ws
end

local function linfit(X, y, w)
   local n, p = matrix.dim(X)
   local ws = get_workspace(n, p)
   local c = matrix.alloc(p, 1)
   local cov = matrix.alloc(p, p)
   local yv = gsl.gsl_matrix_column (y, 0)
   local cv = gsl.gsl_matrix_column (c, 0)

   local chisq = ffi.new('double[1]')

   if w then
      local wv = gsl.gsl_matrix_column (w, 0)
      gsl_check(gsl.gsl_multifit_wlinear(X, wv, yv, cv, cov, chisq, ws))
   else
      gsl_check(gsl.gsl_multifit_linear(X, yv, cv, cov, chisq, ws))
   end

   return c, chisq[0], cov
end

return setmetatable({linfit=linfit}, {__call=function(t,...) return linfit(...) end})
