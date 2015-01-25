local matrix = require("lgsl.matrix")
local nlinfit = require("lgsl.nlinfit")
local pi,sin,cos,exp = math.pi,math.sin, math.cos, math.exp

local function n2str(x)
    return string.format("%.8g", x)
end

local function vec2str(x)
    local t = {}
    for i = 1, #x do
        t[i] = n2str(x[i])
    end
    return table.concat(t, " ")
end

local function donlfit()
   local n = 50
   local px = matrix.vec {1.55, -1.1, 12.5}
   local p0 = matrix.vec {2.5,  -1.5, 5.3}
   local xs = function(i) return (i-1)/n end

   local fmodel = function(p, t, J)
		     local e, s = exp(p[2] * t), sin(p[3] * t)
		     if J then
			J[1] = e * s
			J[2] = t * p[1] * e * s
			J[3] = t * p[1] * e * cos(p[3] * t)
		     end
		     return p[1] * e * s
		  end

   local y = matrix.new(n, 1, function(i,j) return fmodel(px, xs(i)) end)
   local x = matrix.new(n, 1, function(i,j) return xs(i) end)

   local function fdf(p, f, J)
      for k=1, n do
	 local ym = fmodel(p, xs(k), J and J[k])
	 if f then f[k] = ym - y[k] end
      end
   end

   local s = nlinfit {n= n, p= #p0}

   s:set(fdf, p0)
   print('GOAL=: ', vec2str(px))
   print('ITER=', 0, ': ', vec2str(s.x), n2str(s.chisq))

   for i=1, 20 do
      s:iterate()
   end
   print('ITER=', 20, ': ', vec2str(s.x), n2str(s.chisq))
end

donlfit()
