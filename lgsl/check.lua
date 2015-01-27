
local check = {}

local floor = math.floor
local type = type

local function is_integer(x)
   if type(x) == 'number' then
      return (floor(x) == x)
   else
      return false
   end
end

local function is_real(x)
   return type(x) == 'number'
end

function check.integer(x)
   if not is_integer(x) then error('integer expected', 2) end
end

function check.number(x)
   if not is_real(x) then error('number expected', 2) end
end

check.is_integer = is_integer
check.is_real    = is_real

return check
