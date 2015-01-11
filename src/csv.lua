-- csv.lua
--
-- Comma Separated Values parsing utilities.
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

local csv = {}

local function add_number(t, n)
   local v = tonumber(n)
   t[#t+1] = v and v or n
end

function csv.line (s)
   s = s .. ','        -- ending comma
   local t = {}        -- table to collect fields
   local fieldstart = 1
   repeat
      -- next field is quoted? (start with `"'?)
      if string.find(s, '^"', fieldstart) then
	 local a, c
	 local i  = fieldstart
	 repeat
            -- find closing quote
            a, i, c = string.find(s, '"("?)', i+1)
	 until c ~= '"'    -- quote not followed by quote?
	 if not i then error('unmatched "') end
	 local f = string.sub(s, fieldstart+1, i-1)
	 add_number(t, (string.gsub(f, '""', '"')))
	 fieldstart = string.find(s, ',', i) + 1
      else                -- unquoted; find next comma
	 local nexti = string.find(s, ',', fieldstart)
	 add_number(t, string.sub(s, fieldstart, nexti-1))
	 fieldstart = nexti + 1
      end
   until fieldstart > string.len(s)
   return t
end

function csv.read(filename)
   local t = {}
   for line in io.lines(filename) do
      if not string.match('^%s*$', line) then
	 t[#t+1] = csv.line(line)
      end
   end
   return t
end

return csv
