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
compare(sf.hydrogenicR_1(3.0, 2.0)       ,    0.025759948256148471036, "hydrogenicR_1(3.0, 2.0)", TEST_TOL0)
compare(sf.hydrogenicR_1(3.0, 10.0)      ,   9.724727052062819704e-13, "hydrogenicR_1(3.0, 10.0)", TEST_TOL1)
compare(sf.hydrogenicR(4, 1, 3.0, 0.0)   ,                        0.0, "hydrogenicR(4, 1, 3.0, 0.0)", TEST_TOL0)
compare(sf.hydrogenicR(4, 0, 3.0, 2.0)   ,    -0.03623182256981820062, "hydrogenicR(4, 0, 3.0, 2.0)", TEST_TOL2)
compare(sf.hydrogenicR(4, 1, 3.0, 2.0)   ,   -0.028065049083129581005, "hydrogenicR(4, 1, 3.0, 2.0)", TEST_TOL2)
compare(sf.hydrogenicR(4, 2, 3.0, 2.0)   ,     0.14583027278668431009, "hydrogenicR(4, 2, 3.0, 2.0)", TEST_TOL0)
compare(sf.hydrogenicR(100,  0, 3.0, 2.0),  -0.00007938950980052281367, "hydrogenicR(100,  0, 3.0, 2.0)", TEST_TOL3)
compare(sf.hydrogenicR(100, 10, 3.0, 2.0),   7.112823375353605977e-12, "hydrogenicR(100, 10, 3.0, 2.0)", TEST_TOL2)
compare(sf.hydrogenicR(100, 90, 3.0, 2.0),  5.845231751418131548e-245, "hydrogenicR(100, 90, 3.0, 2.0)", TEST_TOL2)
