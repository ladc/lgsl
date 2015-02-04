-- This is a (generated) test script for all the methods in the randist module.

local randist = require("lgsl.randist")
local gsl = require("lgsl.gsl")
local sprintf = function(...) return io.write(string.format(...)) end
local eps = 1e-12
local function compare(val, ref, name)
  local inc = 0
  if val==0 or ref==0 then inc = 1 end
  if gsl.gsl_fcmp(val+inc,ref+inc,eps)==0 then
    sprintf("Pass %-30s: % .15e\n", name, ref,"\n")
  else
    sprintf("Fail %-30s: % .15e ~= % .15e\n", name, val, ref)
  end
end

local x=0.1
local sigma=1
local mu=1
local nu=9
local a=3
local nu1=2
local nu2=4
local b=2
local zeta=1
local p=0.4
local n=8

compare(randist.gaussian_pdf(x, sigma)        ,  3.969525474770118e-01, "gaussian_pdf(x, sigma)")
compare(randist.gaussian_P(x, sigma)          ,  5.398278372770290e-01, "gaussian_P(x, sigma)")
compare(randist.gaussian_Q(x, sigma)          ,  4.601721627229710e-01, "gaussian_Q(x, sigma)")
compare(randist.gaussian_Pinv(x, sigma)       , -1.281551565544601e+00, "gaussian_Pinv(x, sigma)")
compare(randist.gaussian_Qinv(x, sigma)       ,  1.281551565544601e+00, "gaussian_Qinv(x, sigma)")
compare(randist.exponential_pdf(x, mu)        ,  9.048374180359595e-01, "exponential_pdf(x, mu)")
compare(randist.exponential_P(x, mu)          ,  9.516258196404043e-02, "exponential_P(x, mu)")
compare(randist.exponential_Q(x, mu)          ,  9.048374180359595e-01, "exponential_Q(x, mu)")
compare(randist.exponential_Pinv(x, mu)       ,  1.053605156578263e-01, "exponential_Pinv(x, mu)")
compare(randist.exponential_Qinv(x, mu)       ,  2.302585092994045e+00, "exponential_Qinv(x, mu)")
compare(randist.chisq_pdf(x, nu)              ,  1.142894236600128e-06, "chisq_pdf(x, nu)")
compare(randist.chisq_P(x, nu)                ,  2.563032539662434e-08, "chisq_P(x, nu)")
compare(randist.chisq_Q(x, nu)                ,  9.999999743696746e-01, "chisq_Q(x, nu)")
compare(randist.chisq_Pinv(x, nu)             ,  4.168159008146109e+00, "chisq_Pinv(x, nu)")
compare(randist.chisq_Qinv(x, nu)             ,  1.468365657325983e+01, "chisq_Qinv(x, nu)")
compare(randist.laplace_pdf(x, a)             ,  1.612026834136676e-01, "laplace_pdf(x, a)")
compare(randist.laplace_P(x, a)               ,  5.163919497589970e-01, "laplace_P(x, a)")
compare(randist.laplace_Q(x, a)               ,  4.836080502410030e-01, "laplace_Q(x, a)")
compare(randist.laplace_Pinv(x, a)            , -4.828313737302301e+00, "laplace_Pinv(x, a)")
compare(randist.laplace_Qinv(x, a)            ,  4.828313737302301e+00, "laplace_Qinv(x, a)")
compare(randist.tdist_pdf(x, nu)              ,  3.858863266209659e-01, "tdist_pdf(x, nu)")
compare(randist.tdist_P(x, nu)                ,  5.387317760216594e-01, "tdist_P(x, nu)")
compare(randist.tdist_Q(x, nu)                ,  4.612682239783406e-01, "tdist_Q(x, nu)")
compare(randist.tdist_Pinv(x, nu)             , -1.383028738396633e+00, "tdist_Pinv(x, nu)")
compare(randist.tdist_Qinv(x, nu)             ,  1.383028738396633e+00, "tdist_Qinv(x, nu)")
compare(randist.cauchy_pdf(x, a)              ,  1.059855336904963e-01, "cauchy_pdf(x, a)")
compare(randist.cauchy_P(x, a)                ,  5.106064024055355e-01, "cauchy_P(x, a)")
compare(randist.cauchy_Q(x, a)                ,  4.893935975944646e-01, "cauchy_Q(x, a)")
compare(randist.cauchy_Pinv(x, a)             , -9.233050611525762e+00, "cauchy_Pinv(x, a)")
compare(randist.cauchy_Qinv(x, a)             ,  9.233050611525762e+00, "cauchy_Qinv(x, a)")
compare(randist.rayleigh_pdf(x, sigma)        ,  9.950124791926823e-02, "rayleigh_pdf(x, sigma)")
compare(randist.rayleigh_P(x, sigma)          ,  4.987520807317688e-03, "rayleigh_P(x, sigma)")
compare(randist.rayleigh_Q(x, sigma)          ,  9.950124791926823e-01, "rayleigh_Q(x, sigma)")
compare(randist.rayleigh_Pinv(x, sigma)       ,  4.590436050264208e-01, "rayleigh_Pinv(x, sigma)")
compare(randist.rayleigh_Qinv(x, sigma)       ,  2.145966026289347e+00, "rayleigh_Qinv(x, sigma)")
compare(randist.fdist_pdf(x, nu1, nu2)        ,  8.638375985314765e-01, "fdist_pdf(x, nu1, nu2)")
compare(randist.fdist_P(x, nu1, nu2)          ,  9.297052154195022e-02, "fdist_P(x, nu1, nu2)")
compare(randist.fdist_Q(x, nu1, nu2)          ,  9.070294784580498e-01, "fdist_Q(x, nu1, nu2)")
compare(randist.fdist_Pinv(x, nu1, nu2)       ,  1.081851067789194e-01, "fdist_Pinv(x, nu1, nu2)")
compare(randist.fdist_Qinv(x, nu1, nu2)       ,  4.324555320336761e+00, "fdist_Qinv(x, nu1, nu2)")
compare(randist.gamma_pdf(x, a, b)            ,  5.945183903129460e-04, "gamma_pdf(x, a, b)")
compare(randist.gamma_P(x, a, b)              ,  2.006749362439790e-05, "gamma_P(x, a, b)")
compare(randist.gamma_Q(x, a, b)              ,  9.999799325063756e-01, "gamma_Q(x, a, b)")
compare(randist.gamma_Pinv(x, a, b)           ,  2.204130656498644e+00, "gamma_Pinv(x, a, b)")
compare(randist.gamma_Qinv(x, a, b)           ,  1.064464067566841e+01, "gamma_Qinv(x, a, b)")
compare(randist.beta_pdf(x, a, b)             ,  1.079999999999999e-01, "beta_pdf(x, a, b)")
compare(randist.beta_P(x, a, b)               ,  3.699999999999995e-03, "beta_P(x, a, b)")
compare(randist.beta_Q(x, a, b)               ,  9.963000000000000e-01, "beta_Q(x, a, b)")
compare(randist.beta_Pinv(x, a, b)            ,  3.204605837218185e-01, "beta_Pinv(x, a, b)")
compare(randist.beta_Qinv(x, a, b)            ,  8.574406832899693e-01, "beta_Qinv(x, a, b)")
compare(randist.gaussian_tail_pdf(5, a, sigma),  1.101356902446165e-03, "gaussian_tail_pdf(5, a, sigma)")
compare(randist.exppow_pdf(x, a, b)           ,  1.878543514563088e-01, "exppow_pdf(x, a, b)")
compare(randist.exppow_P(x, a, b)             ,  5.187993564692450e-01, "exppow_P(x, a, b)")
compare(randist.exppow_Q(x, a, b)             ,  4.812006435307550e-01, "exppow_Q(x, a, b)")
compare(randist.lognormal_pdf(x, zeta, sigma) ,  1.707930831120359e-02, "lognormal_pdf(x, zeta, sigma)")
compare(randist.lognormal_P(x, zeta, sigma)   ,  4.789900863651144e-04, "lognormal_P(x, zeta, sigma)")
compare(randist.lognormal_Q(x, zeta, sigma)   ,  9.995210099136349e-01, "lognormal_Q(x, zeta, sigma)")
compare(randist.lognormal_Pinv(x, zeta, sigma),  7.546120026931251e-01, "lognormal_Pinv(x, zeta, sigma)")
compare(randist.lognormal_Qinv(x, zeta, sigma),  9.791861344054885e+00, "lognormal_Qinv(x, zeta, sigma)")
compare(randist.binomial_pdf(x, p, n)         ,  1.679615999999999e-02, "binomial_pdf(x, p, n)")
compare(randist.binomial_P(x, p, n)           ,  1.679615999999999e-02, "binomial_P(x, p, n)")
compare(randist.binomial_Q(x, p, n)           ,  9.832038400000001e-01, "binomial_Q(x, p, n)")
compare(randist.poisson_pdf(x, mu)            ,  3.678794411714423e-01, "poisson_pdf(x, mu)")
compare(randist.poisson_P(x, mu)              ,  3.678794411714423e-01, "poisson_P(x, mu)")
compare(randist.poisson_Q(x, mu)              ,  6.321205588285578e-01, "poisson_Q(x, mu)")
