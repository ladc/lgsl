local template = require 'lgsl.template'
local check = require 'lgsl.check'
local q_default

local function integ(f, a, b, epsabs, epsrel)
   epsabs = epsabs or 1e-8
   epsrel = epsrel or 1e-8

   check.number(a)
   check.number(b)
   
   if not q_default then
      q_default = template.load('qag', {limit= 64, order= 21})
   end

   local result = q_default (f, a, b, epsabs, epsrel)

   return result
end

return integ
