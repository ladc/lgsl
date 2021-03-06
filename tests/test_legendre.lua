local gsl = require("lgsl.gsl")
local sf = require("lgsl.sf")
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
local TEST_SQRT_TOL0 = (2.0*GSL_SQRT_DBL_EPSILON)
compare(sf.legendreP(1, -0.5)            ,                       -0.5, "legendreP(1, -0.5)", TEST_TOL0)
compare(sf.legendreP(1,  1.0e-8)         ,                    1.0e-08, "legendreP(1,  1.0e-8)", TEST_TOL0)
compare(sf.legendreP(1,  0.5)            ,                        0.5, "legendreP(1,  0.5)", TEST_TOL0)
compare(sf.legendreP(1,  1.0)            ,                        1.0, "legendreP(1,  1.0)", TEST_TOL0)
compare(sf.legendreP(10, -0.5)           ,        -0.1882286071777345, "legendreP(10, -0.5)", TEST_TOL0)
compare(sf.legendreP(10,  1.0e-8)        ,    -0.24609374999999864648, "legendreP(10,  1.0e-8)", TEST_TOL0)
compare(sf.legendreP(10,  0.5)           ,    -0.18822860717773437500, "legendreP(10,  0.5)", TEST_TOL0)
compare(sf.legendreP(10,  1.0)           ,                        1.0, "legendreP(10,  1.0)", TEST_TOL0)
compare(sf.legendreP(99, -0.5)           ,     0.08300778172138770477, "legendreP(99, -0.5)", TEST_TOL0)
compare(sf.legendreP(99,  1.0e-8)        ,  -7.958923738716563193e-08, "legendreP(99,  1.0e-8)", TEST_TOL0)
compare(sf.legendreP(99,  0.5)           ,    -0.08300778172138770477, "legendreP(99,  0.5)", TEST_TOL0)
compare(sf.legendreP(99,  0.999)         ,     -0.3317727359254778874, "legendreP(99,  0.999)", TEST_TOL2)
compare(sf.legendreP(99,  1.0)           ,                        1.0, "legendreP(99,  1.0)", TEST_TOL0)
compare(sf.legendreP(1000, -0.5)         ,   -0.019168251091650277878, "legendreP(1000, -0.5)", TEST_TOL2)
compare(sf.legendreP(1000,  1.0e-8)      ,  0.0252250181770982897470252620, "legendreP(1000,  1.0e-8)", TEST_TOL2)
compare(sf.legendreP(1000,  0.5)         ,   -0.019168251091650277878, "legendreP(1000,  0.5)", TEST_TOL2)
compare(sf.legendreP(1000,  1.0)         ,                        1.0, "legendreP(1000,  1.0)", TEST_TOL0)
compare(sf.legendreP(4000, -0.5)         ,   -0.009585404456573080972, "legendreP(4000, -0.5)", TEST_TOL2)
compare(sf.legendreP(4000,  0.5)         ,   -0.009585404456573080972, "legendreP(4000,  0.5)", TEST_TOL2)
compare(sf.legendreP(4000,  1.0)         ,                        1.0, "legendreP(4000,  1.0)", TEST_TOL0)
compare(sf.legendrePlm(10, 0, -0.5)      ,    -0.18822860717773437500, "legendrePlm(10, 0, -0.5)", TEST_TOL0)
compare(sf.legendrePlm(10, 0, 1.0e-08)   ,    -0.24609374999999864648, "legendrePlm(10, 0, 1.0e-08)", TEST_TOL0)
compare(sf.legendrePlm(10, 0, 0.5)       ,    -0.18822860717773437500, "legendrePlm(10, 0, 0.5)", TEST_TOL0)
compare(sf.legendrePlm(10, 1, -0.5)      ,     -2.0066877394361256516, "legendrePlm(10, 1, -0.5)", TEST_TOL0)
compare(sf.legendrePlm(10, 1, 1.0e-08)   ,  -2.7070312499999951725e-07, "legendrePlm(10, 1, 1.0e-08)", TEST_TOL0)
compare(sf.legendrePlm(10, 1, 0.5)       ,      2.0066877394361256516, "legendrePlm(10, 1, 0.5)", TEST_TOL0)
compare(sf.legendrePlm(10, 5, -0.5)      ,     -30086.169706116174977, "legendrePlm(10, 5, -0.5)", TEST_TOL0)
compare(sf.legendrePlm(10, 5, 1.0e-08)   ,  -0.0025337812499999964949, "legendrePlm(10, 5, 1.0e-08)", TEST_TOL0)
compare(sf.legendrePlm(10, 5, 0.5)       ,      30086.169706116174977, "legendrePlm(10, 5, 0.5)", TEST_TOL0)
compare(sf.legendrePlm(10, 5, 0.999)     ,     -0.5036411489013270406, "legendrePlm(10, 5, 0.999)", TEST_TOL1)
compare(sf.legendrePlm(100, 5, -0.5)     ,  -6.617107444248382171e+08, "legendrePlm(100, 5, -0.5)", TEST_TOL0)
compare(sf.legendrePlm(100, 5, 1.0e-08)  ,       817.8987598063712851, "legendrePlm(100, 5, 1.0e-08)", TEST_TOL0)
compare(sf.legendrePlm(100, 5, 0.5)      ,   6.617107444248382171e+08, "legendrePlm(100, 5, 0.5)", TEST_TOL0)
compare(sf.legendrePlm(100, 5, 0.999)    ,  -1.9831610803806212189e+09, "legendrePlm(100, 5, 0.999)", TEST_TOL2)
compare(sf.legendresphPlm(10, 0, -0.5)   ,    -0.24332702369300133776, "legendresphPlm(10, 0, -0.5)", TEST_TOL0)
compare(sf.legendresphPlm(10, 0, 0.5)    ,    -0.24332702369300133776, "legendresphPlm(10, 0, 0.5)", TEST_TOL0)
compare(sf.legendresphPlm(10, 0, 0.999)  ,      1.2225754122797385990, "legendresphPlm(10, 0, 0.999)", TEST_TOL1)
compare(sf.legendresphPlm(10, 5, -0.5)   ,     -0.3725739049803293972, "legendresphPlm(10, 5, -0.5)", TEST_TOL0)
compare(sf.legendresphPlm(10, 5, 1.0e-08),  -3.1377233589376792243e-08, "legendresphPlm(10, 5, 1.0e-08)", TEST_TOL0)
compare(sf.legendresphPlm(10, 5, 0.5)    ,      0.3725739049803293972, "legendresphPlm(10, 5, 0.5)", TEST_TOL0)
compare(sf.legendresphPlm(10, 5, 0.999)  ,  -6.236870674727370094e-06, "legendresphPlm(10, 5, 0.999)", TEST_TOL2)
compare(sf.legendresphPlm(10, 10, -0.5)  ,     0.12876871185785724117, "legendresphPlm(10, 10, -0.5)", TEST_TOL1)
compare(sf.legendresphPlm(10, 10, 0.5)   ,     0.12876871185785724117, "legendresphPlm(10, 10, 0.5)", TEST_TOL1)
compare(sf.legendresphPlm(10, 10, 0.999) ,  1.7320802307583118647e-14, "legendresphPlm(10, 10, 0.999)", TEST_TOL2)
compare(sf.legendresphPlm(200, 1, -0.5)  ,      0.3302975570099492931, "legendresphPlm(200, 1, -0.5)", TEST_TOL1)
compare(sf.legendresphPlm(200, 1, 0.5)   ,     -0.3302975570099492931, "legendresphPlm(200, 1, 0.5)", TEST_TOL1)
compare(sf.legendresphPlm(200, 1, 0.999) ,     -1.4069792055546256912, "legendresphPlm(200, 1, 0.999)", TEST_TOL2)
compare(sf.legendresphPlm(3, 1, 0.0)     ,    0.323180184114150653007, "legendresphPlm(3, 1, 0.0)", TEST_TOL2)
compare(sf.legendresphPlm(200, 1, -0.5)  ,  0.3302975570099492931418227583, "legendresphPlm(200, 1, -0.5)", TEST_TOL2)
compare(sf.legendresphPlm(140,135,1)     ,                        0.0, "legendresphPlm(140,135,1)", TEST_TOL2)
compare(sf.legendresphPlm(140,135,0.99998689456491752),  -6.54265253269093276310395668335e-305, "legendresphPlm(140,135,0.99998689456491752)", TEST_TOL6)
compare(sf.conicalPsphreg(2,  1.0, -0.5) ,      1.6406279287008789526, "conicalPsphreg(2,  1.0, -0.5)", TEST_TOL0)
compare(sf.conicalPsphreg(10, 1.0, -0.5) ,  0.000029315266725049129448, "conicalPsphreg(10, 1.0, -0.5)", TEST_TOL1)
compare(sf.conicalPsphreg(20, 1.0, -0.5) ,   7.335769429462034431e-15, "conicalPsphreg(20, 1.0, -0.5)", TEST_TOL1)
compare(sf.conicalPsphreg(30, 1.0, -0.5) ,  1.3235612394267378871e-26, "conicalPsphreg(30, 1.0, -0.5)", TEST_TOL2)
compare(sf.conicalPsphreg(10, 1.0, 0.5)  ,  2.7016087199857873954e-10, "conicalPsphreg(10, 1.0, 0.5)", TEST_TOL1)
compare(sf.conicalPsphreg(20, 1.0, 0.5)  ,  1.1782569701435933399e-24, "conicalPsphreg(20, 1.0, 0.5)", TEST_TOL1)
compare(sf.conicalPsphreg(30, 1.0, 0.5)  ,   3.636240588303797919e-41, "conicalPsphreg(30, 1.0, 0.5)", TEST_TOL1)
compare(sf.conicalPsphreg(10, 1.0, 2.0)  ,  2.4934929626284934483e-10, "conicalPsphreg(10, 1.0, 2.0)", TEST_TOL1)
compare(sf.conicalPsphreg(20, 1.0, 2.0)  ,  1.1284762488012616191e-24, "conicalPsphreg(20, 1.0, 2.0)", TEST_TOL2)
compare(sf.conicalPsphreg(30, 100.0, 100.0),  -1.6757772087159526048e-64, "conicalPsphreg(30, 100.0, 100.0)", TEST_TOL6)
compare(sf.conicalPcylreg(2, 1.0, -0.5)  ,      2.2048510472375258708, "conicalPcylreg(2, 1.0, -0.5)", TEST_TOL0)
compare(sf.conicalPcylreg(10, 1.0, -0.5) ,  0.00007335034531618655690, "conicalPcylreg(10, 1.0, -0.5)", TEST_TOL1)
compare(sf.conicalPcylreg(20, 1.0, -0.5) ,  2.5419860619212164696e-14, "conicalPcylreg(20, 1.0, -0.5)", TEST_TOL1)
compare(sf.conicalPcylreg(30, 1.0, -0.5) ,   5.579714972260536827e-26, "conicalPcylreg(30, 1.0, -0.5)", TEST_TOL2)
compare(sf.conicalPcylreg(10, 1.0, 0.5)  ,  1.1674078819646475282e-09, "conicalPcylreg(10, 1.0, 0.5)", TEST_TOL0)
compare(sf.conicalPcylreg(20, 1.0, 0.5)  ,   7.066408031229072207e-24, "conicalPcylreg(20, 1.0, 0.5)", TEST_TOL1)
compare(sf.conicalPcylreg(30, 1.0, 0.5)  ,  2.6541973286862588488e-40, "conicalPcylreg(30, 1.0, 0.5)", TEST_TOL1)
compare(sf.conicalPcylreg(10, 1.0, 2.0)  ,  1.0736109751890863051e-09, "conicalPcylreg(10, 1.0, 2.0)", TEST_TOL2)
compare(sf.conicalPcylreg(20, 1.0, 2.0)  ,   6.760965304863386741e-24, "conicalPcylreg(20, 1.0, 2.0)", TEST_TOL2)
compare(sf.conicalPcylreg(30, 100.0, 100.0),  -4.268753482520651007e-63, "conicalPcylreg(30, 100.0, 100.0)", TEST_TOL4)
compare(sf.legendreH3d(5, 1.0e-06, 1.0e-06),  1.1544011544013627977e-32, "legendreH3d(5, 1.0e-06, 1.0e-06)", TEST_TOL2)
compare(sf.legendreH3d(5, 1.0, 1.0e-10)  ,  2.0224912016958766992e-52, "legendreH3d(5, 1.0, 1.0e-10)", TEST_TOL2)
compare(sf.legendreH3d(5, 1.0, 1.0)      ,    0.011498635037491577728, "legendreH3d(5, 1.0, 1.0)", TEST_TOL1)
compare(sf.legendreH3d(5, 1.0, 5.0)      ,   0.0020696945662545205776, "legendreH3d(5, 1.0, 5.0)", TEST_TOL4)
compare(sf.legendreH3d(5, 1.0, 7.0)      ,  -0.0017555303787488993676, "legendreH3d(5, 1.0, 7.0)", TEST_TOL4)
compare(sf.legendreH3d(5, 1.0, 10.0)     ,  0.00008999979724504887101, "legendreH3d(5, 1.0, 10.0)", TEST_TOL2)
compare(sf.legendreH3d(5, 1.0, 100.0)    ,  -4.185397793298567945e-44, "legendreH3d(5, 1.0, 100.0)", TEST_TOL2)
compare(sf.legendreH3d(5, 1.0, 500.0)    ,  1.4235113901091961263e-217, "legendreH3d(5, 1.0, 500.0)", TEST_TOL3)
compare(sf.legendreH3d(5, 100.0, 0.001)  ,   9.642762597222417946e-10, "legendreH3d(5, 100.0, 0.001)", TEST_TOL2)
compare(sf.legendreH3d(5, 100.0, 0.002)  ,  3.0821201254308036109e-08, "legendreH3d(5, 100.0, 0.002)", TEST_TOL2)
compare(sf.legendreH3d(5, 100.0, 0.01)   ,  0.00009281069019005840532, "legendreH3d(5, 100.0, 0.01)", TEST_TOL1)
compare(sf.legendreH3d(5, 100.0, 1.0)    ,   -0.008043100696178624653, "legendreH3d(5, 100.0, 1.0)", TEST_TOL2)
compare(sf.legendreH3d(5, 100.0, 10.0)   ,  -3.927678432813974207e-07, "legendreH3d(5, 100.0, 10.0)", TEST_TOL3)
compare(sf.legendreH3d(5, 1000.0, 0.001) ,  0.00009256365284253254503, "legendreH3d(5, 1000.0, 0.001)", TEST_TOL1)
compare(sf.legendreH3d(5, 1000.0, 0.01)  ,    -0.05553733815473079983, "legendreH3d(5, 1000.0, 0.01)", TEST_TOL0)
compare(sf.legendreH3d(5, 1.0e+08, 1.0e-08),  0.00009256115861125841299, "legendreH3d(5, 1.0e+08, 1.0e-08)", TEST_TOL2)
compare(sf.legendreH3d(5, 1.0e+08, 100.0),  -6.496143209092860765e-52 , "legendreH3d(5, 1.0e+08, 100.0)", 128.0*TEST_SQRT_TOL0)
compare(sf.legendreQ(10, -0.5)           ,    -0.29165813966586752393, "legendreQ(10, -0.5)", TEST_TOL0)
compare(sf.legendreQ(10,  0.5)           ,     0.29165813966586752393, "legendreQ(10,  0.5)", TEST_TOL0)
compare(sf.legendreQ(10,  1.5)           ,  0.000014714232718207477406, "legendreQ(10,  1.5)", TEST_TOL0)
compare(sf.legendreQ(100, -0.5)          ,    -0.09492507395207282096, "legendreQ(100, -0.5)", TEST_TOL1)
compare(sf.legendreQ(100,  0.5)          ,     0.09492507395207282096, "legendreQ(100,  0.5)", TEST_TOL1)
compare(sf.legendreQ(100,  1.5)          ,  1.1628163435044121988e-43, "legendreQ(100,  1.5)", TEST_TOL2)
compare(sf.legendreQ(1000, -0.5)         ,   -0.030105074974005303500, "legendreQ(1000, -0.5)", TEST_TOL1)
compare(sf.legendreQ(1000,  0.5)         ,    0.030105074974005303500, "legendreQ(1000,  0.5)", TEST_TOL1)
compare(sf.legendreQ(1000,  1.1)         ,  1.0757258447825356443e-194, "legendreQ(1000,  1.1)", TEST_TOL3)
