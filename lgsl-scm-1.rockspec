package = "lgsl"
version = "scm-1"
source = {
   url = "git://github.com/ladc/lgsl",
}
description = {
   summary = "LGSL: the Lua GSL project",
   detailed = [[
      LGSL is a collection of numeric algorithms and functions for Lua, based on the
      GNU Scientific Library (GSL). It allows matrix/vector manipulation and linear
      algebra operations. 

      LGSL is not just a wrapper over the C API of GSL but offers a much more simple
      and expressive way to use GSL. The objective of LGSL is to give the user the
      power to easily access GSL functions without having to write a complete C
      application.
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
      ["lgsl"] = "lgsl.lua",
      -- utilities
      ["lgsl.sort"] = "sort.lua",
      ["lgsl.check"] = "check.lua",
      ["lgsl.gsl-check"] = "gsl-check.lua",
      ["lgsl.gsl"] = "gsl.lua",
      ["lgsl.template"] = "template.lua",
      -- loaded in lgsl
      ["lgsl.matrix"] = "matrix.lua",
      ["lgsl.complex"] = "complex.lua",
      ["lgsl.eigen"] = "eigen.lua",
      ["lgsl.iter"] = "iter.lua",
      ["lgsl.rng"] = "rng.lua",
      ["lgsl.rnd"] = "rnd.lua",
      ["lgsl.randist"] = "randist.lua",
      ["lgsl.sf"] = "sf.lua",
      ["lgsl.csv"] = "csv.lua",
      ["lgsl.bspline"] = "bspline.lua",
      ["lgsl.fft"] = "fft.lua",
      ["lgsl.integ"] = "integ.lua",
      ["lgsl.linfit"] = "linfit.lua",
      ["lgsl.nlinfit"] = "nlinfit.lua",
      ["lgsl.ode"] = "ode.lua",
      ["lgsl.quad_prepare"] = "quad_prepare.lua",
      ["lgsl.vegas_prepare"] = "vegas_prepare.lua",
   },
   install = {
      lua = {
          ["lgsl.templates.gauss-kronrod-x-wgs"] = "templates/gauss-kronrod-x-wgs.lua.in",
          ["lgsl.templates.lmfit"] = "templates/lmfit.lua.in",
          ["lgsl.templates.ode-defs"] = "templates/ode-defs.lua.in",
          ["lgsl.templates.qag"] = "templates/qag.lua.in",
          ["lgsl.templates.qng"] = "templates/qng.lua.in",
          ["lgsl.templates.rk4"] = "templates/rk4.lua.in",
          ["lgsl.templates.rk8pd"] = "templates/rk8pd.lua.in",
          ["lgsl.templates.rkf45"] = "templates/rkf45.lua.in",
          ["lgsl.templates.rkf45vec"] = "templates/rkf45vec.lua.in",
          ["lgsl.templates.rnd-defs"] = "templates/rnd-defs.lua.in",
          ["lgsl.templates.sf-defs"] = "templates/sf-defs.lua.in",
          ["lgsl.templates.vegas-defs"] = "templates/vegas-defs.lua.in",
      },
   },
   copy_directories = { "demos" },
}
