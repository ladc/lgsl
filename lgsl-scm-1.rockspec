package = "lgsl"
version = "scm-1"
source = {
   url = "git://github.com/ladc/lgsl",
}
description = {
   summary = "Numerical algorithms for Lua based on the GSL Library",
   detailed = [[
      LGSL is a collection of numerical algorithms and functions for Lua, based on the
      GNU Scientific Library (GSL). It allows matrix/vector manipulation and linear
      algebra operations. 

      LGSL is not just a wrapper over the C API of GSL but offers a much more
      simple and expressive way to use GSL. The objective of LGSL is to give
      the user the power to easily access GSL functions without having to write
      a complete C application.

      LGSL is based on the numerical modules of GSL Shell.
   ]],
   homepage = "http://www.nongnu.org/gsl-shell/",
   license = "GPL-3",
   maintainer = "Lesley De Cruz <lesley.decruz+lgsl@gmail.com>"
}
dependencies = {
   "lua == 5.1" -- this should be luajit2
}
external_dependencies = {
   GSL = {
      library = "gsl"
   },
}
build = {
   type = "builtin",
   modules = {
      ["lgsl.init"] = "src/init.lua",
      -- utilities
      ["lgsl.sort"] = "src/sort.lua",
      ["lgsl.check"] = "src/check.lua",
      ["lgsl.gsl-check"] = "src/gsl-check.lua",
      ["lgsl.gsl"] = "src/gsl.lua",
      ["lgsl.template"] = "src/template.lua",
      -- loaded in lgsl
      ["lgsl.matrix"] = "src/matrix.lua",
      ["lgsl.complex"] = "src/complex.lua",
      ["lgsl.eigen"] = "src/eigen.lua",
      ["lgsl.iter"] = "src/iter.lua",
      ["lgsl.rng"] = "src/rng.lua",
      ["lgsl.rnd"] = "src/rnd.lua",
      ["lgsl.randist"] = "src/randist.lua",
      ["lgsl.sf"] = "src/sf.lua",
      ["lgsl.csv"] = "src/csv.lua",
      ["lgsl.bspline"] = "src/bspline.lua",
      ["lgsl.fft"] = "src/fft.lua",
      ["lgsl.integ"] = "src/integ.lua",
      ["lgsl.linfit"] = "src/linfit.lua",
      ["lgsl.nlinfit"] = "src/nlinfit.lua",
      ["lgsl.ode"] = "src/ode.lua",
      ["lgsl.quad_prepare"] = "src/quad_prepare.lua",
      ["lgsl.vegas_prepare"] = "src/vegas_prepare.lua",
   },
   install = {
      lua = {
          ["lgsl.templates.gauss-kronrod-x-wgs"] = "src/templates/gauss-kronrod-x-wgs.lua.in",
          ["lgsl.templates.lmfit"] = "src/templates/lmfit.lua.in",
          ["lgsl.templates.ode-defs"] = "src/templates/ode-defs.lua.in",
          ["lgsl.templates.qag"] = "src/templates/qag.lua.in",
          ["lgsl.templates.qng"] = "src/templates/qng.lua.in",
          ["lgsl.templates.rk4"] = "src/templates/rk4.lua.in",
          ["lgsl.templates.rk8pd"] = "src/templates/rk8pd.lua.in",
          ["lgsl.templates.rkf45"] = "src/templates/rkf45.lua.in",
          ["lgsl.templates.rkf45vec"] = "src/templates/rkf45vec.lua.in",
          ["lgsl.templates.rnd-defs"] = "src/templates/rnd-defs.lua.in",
          ["lgsl.templates.sf-defs"] = "src/templates/sf-defs.lua.in",
          ["lgsl.templates.vegas-defs"] = "src/templates/vegas-defs.lua.in",
      },
   },
   copy_directories = { "demos" },
}
