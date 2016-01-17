-- lgsl.lua
-- 
-- Load LGSL modules into the lgsl table.
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
--

local lgsl = {
  matrix = require("lgsl.matrix"),
  complex = require("lgsl.complex"),
  eigen = require("lgsl.eigen"),
  iter = require("lgsl.iter"),
  rng = require("lgsl.rng"),
  rnd = require("lgsl.rnd"),
  randist = require("lgsl.randist"),
  sf = require("lgsl.sf"),
  csv = require("lgsl.csv"),
  bspline = require("lgsl.bspline"),
  fft = require("lgsl.fft"),
  integ = require("lgsl.integ"),
  linfit = require("lgsl.linfit"),
  nlinfit = require("lgsl.nlinfit"),
  ode = require("lgsl.ode"),
  vegas = require("lgsl.vegas"),
}

return lgsl
