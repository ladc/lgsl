local graph = require("graph")
local lgsl = require("lgsl")
local rng,rnd,matrix,complex,iter,f = lgsl.rng,lgsl.rnd,lgsl.matrix,lgsl.complex,lgsl.iter,lgsl.fft
local fft, fftinv = f.fft, f.fftinv
local sqrt, pi, exp, floor = math.sqrt, math.pi, math.exp, math.floor

local function gaussian()
   local N = 800
   local r = rng.new()
   local f = function(x) return 1/sqrt(2*pi) * exp(-x^2/2) end
   local p = graph.plot('Simulated Gaussian Distribution')
   local b = graph.ibars(iter.sample(function(x) return rnd.poisson(r, floor(f(x)*N)) / N end, -3, 3, 25))
   p:add(b, 'darkgreen')
   p:addline(b, graph.rgba(0, 0, 0, 150))
   p:addline(graph.fxline(f, -4, 4), 'red')
   p.xtitle, p.ytitle = 'x', 'Frequency'
   p:show()
   return p
end

-- FFT example, frequency cut on square pulse and plot of result
local function fftplot()
   local n = 256
   local ncut = 16

   local v = matrix.new(n, 1, function(i) return i < n/3 and 0 or (i < 2*n/3 and 1 or 0) end)

   local pt, pf = graph.plot('Original / Reconstructed signal'), graph.plot('FFT Spectrum')

   pt:addline(graph.filine(function(i) return v[i] end, n), 'black')

   local ft = fft(v, true)

   pf:add(graph.ibars(iter.isample(function(i) return complex.abs(ft[i]) end, 0, n/2)), 'black')
   for k=ncut, n/2 do ft[k] = 0 end

   fftinv(ft, true)

   pt:addline(graph.filine(function(i) return v[i] end, n), 'red')

   pf:show()
   pt:show()

   return pt, pf
end

return {'Plotting', {
  {
     name= 'gaussian',
     f = gaussian,
     description = 'Bar Plot example'
  },
  {
     name= 'fftplot',
     f = fftplot,
     description = 'FFT Plot example'
  },
}}
