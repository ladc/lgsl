-- bspline.lua
--
-- B-splines: basis functions to fit smoothing curves to large data sets.
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
local matrix = require("lgsl.matrix") 
local gsl_check = require("lgsl.gsl-check")

local function eval(bs, x)
   local dof, ws = bs.dof, bs.ws
   local c = matrix.alloc(dof, 1)
   local v = gsl.gsl_matrix_column (c, 0)
   gsl_check(gsl.gsl_bspline_eval(x, v, ws))
   return c
end

local function model(bs, x)
   local dof, ws = bs.dof, bs.ws
   local n = matrix.dim(x)
   local m = matrix.alloc(n, dof)
   for j = 0, n-1 do
      local xj = gsl.gsl_matrix_get(x, j, 0)
      local v = gsl.gsl_matrix_row (m, j)
      gsl_check(gsl.gsl_bspline_eval(xj, v, ws))
   end
   return m
end

local mt = {
   __index = {eval= eval, model= model}
}

local function bspline(a, b, nbreak)
   local breaks
   local brk
   if type(a) ~= 'number' then
      breaks = type(a) == 'table' and matrix.vec(a) or a
      brk = gsl.gsl_matrix_column (breaks, 0)
      nbreak = #breaks
   end

   local k = 4
   local dof = nbreak + k - 2
   local ws = ffi.gc(gsl.gsl_bspline_alloc (k, nbreak), gsl.gsl_bspline_free)

   if breaks then
      gsl_check(gsl.gsl_bspline_knots (brk, ws))
   else
      gsl_check(gsl.gsl_bspline_knots_uniform (a, b, ws))
   end

   local bs = {dof= dof, ws= ws}
   setmetatable(bs, mt)

   return bs
end

return setmetatable({bspline=bspline}, {__call=function(t,...) return bspline(...) end})
