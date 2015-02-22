local gsl = require("lgsl.gsl")
local sf= require("lgsl.sf")
local GSL_DBL_EPSILON, GSL_SQRT_DBL_EPSILON, GSL_LOG_DBL_MAX = 2.2204460492503131e-16, 1.4901161193847656e-08, 7.0978271289338397e+02
local function sprintf(...) io.write(string.format(...)) end
local sqrt, log, exp, M_PI, M_PI_2, DBL_MAX = math.sqrt, math.log, math.exp, math.pi, math.pi/2, 1.7976931348623157E+308
local function compare(val, ref, name, eps)
  eps = eps or 1e-9
  local inc = 0
  if val==0 or ref==0 then inc = 1 end
  if gsl.gsl_fcmp(val+inc,ref+inc,eps*100)==0 then
    sprintf("Pass %-30s: % .15e\n", name, ref,"\n")
  else
    sprintf("Fail %-30s: % .15e ~= % .15e\n", name, val, ref)
  end
end
local TEST_TOL0 = (2.0*GSL_DBL_EPSILON)
local TEST_TOL1 = (16.0*GSL_DBL_EPSILON)
local TEST_TOL2 = (256.0*GSL_DBL_EPSILON)
local TEST_TOL3 = (2048.0*GSL_DBL_EPSILON)
local TEST_TOL4 = (16384.0*GSL_DBL_EPSILON)
local TEST_TOL5 = (131072.0*GSL_DBL_EPSILON)
local TEST_TOL6 = (1048576.0*GSL_DBL_EPSILON)
compare(sf.dilog(-3.0)                   ,     -1.9393754207667089531, "dilog(-3.0)", TEST_TOL0)
compare(sf.dilog(-0.5)                   ,     -0.4484142069236462024, "dilog(-0.5)", TEST_TOL0)
compare(sf.dilog(-0.001)                 ,  -0.0009997501110486510834, "dilog(-0.001)", TEST_TOL0)
compare(sf.dilog(0.1)                    ,         0.1026177910993911, "dilog(0.1)", TEST_TOL0)
compare(sf.dilog(0.7)                    ,      0.8893776242860387386, "dilog(0.7)", TEST_TOL0)
compare(sf.dilog(1.0)                    ,         1.6449340668482260, "dilog(1.0)", TEST_TOL0)
compare(sf.dilog(1.5)                    ,      2.3743952702724802007, "dilog(1.5)", TEST_TOL0)
compare(sf.dilog(2.0)                    ,         2.4674011002723397, "dilog(2.0)", TEST_TOL0)
compare(sf.dilog( 5.0)                   ,      1.7837191612666306277, "dilog( 5.0)", TEST_TOL0)
compare(sf.dilog( 11.0)                  ,      0.3218540439999117111, "dilog( 11.0)", TEST_TOL1)
compare(sf.dilog(12.59)                  ,   0.0010060918167266208634, "dilog(12.59)", TEST_TOL3)
compare(sf.dilog(12.595)                 ,  0.00003314826006436236810, "dilog(12.595)", TEST_TOL5)
compare(sf.dilog(13.0)                   ,    -0.07806971248458575855, "dilog(13.0)", TEST_TOL2)
compare(sf.dilog(20.0)                   ,     -1.2479770861745251168, "dilog(20.0)", TEST_TOL2)
compare(sf.dilog(150.0)                  ,      -9.270042702348657270, "dilog(150.0)", TEST_TOL0)
compare(sf.dilog(1100.0)                 ,     -21.232504073931749553, "dilog(1100.0)", TEST_TOL0)
