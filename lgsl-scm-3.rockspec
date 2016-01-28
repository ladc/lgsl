package = "LGSL"
version = "scm-3"
source = {
   url = "https://github.com/ladc/lgsl/archive/master.zip",
   dir = "lgsl-master"
}
description = {
   summary = "A numerical library for Lua based on GSL",
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
   homepage = "https://github.com/ladc/lgsl",
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
      ["lgsl.init"] = "lgsl.lua",
      -- utilities
      ["lgsl.sort"] = "lgsl/sort.lua",
      ["lgsl.check"] = "lgsl/check.lua",
      ["lgsl.gsl-check"] = "lgsl/gsl-check.lua",
      ["lgsl.gsl"] = "lgsl/gsl.lua",
      ["lgsl.template"] = "lgsl/template.lua",
      -- loaded in lgsl
      ["lgsl.matrix"] = "lgsl/matrix.lua",
      ["lgsl.complex"] = "lgsl/complex.lua",
      ["lgsl.eigen"] = "lgsl/eigen.lua",
      ["lgsl.iter"] = "lgsl/iter.lua",
      ["lgsl.rng"] = "lgsl/rng.lua",
      ["lgsl.rnd"] = "lgsl/rnd.lua",
      ["lgsl.randist"] = "lgsl/randist.lua",
      ["lgsl.sf"] = "lgsl/sf.lua",
      ["lgsl.csv"] = "lgsl/csv.lua",
      ["lgsl.bspline"] = "lgsl/bspline.lua",
      ["lgsl.fft"] = "lgsl/fft.lua",
      ["lgsl.integ"] = "lgsl/integ.lua",
      ["lgsl.linfit"] = "lgsl/linfit.lua",
      ["lgsl.nlinfit"] = "lgsl/nlinfit.lua",
      ["lgsl.ode"] = "lgsl/ode.lua",
      ["lgsl.vegas"] = "lgsl/vegas.lua",
      ["lgsl.demos"] = "demos/demos.lua",
   },
   install = {
      lua = {
          -- templates
          ["lgsl.templates.gauss-kronrod-x-wgs"] = "lgsl/templates/gauss-kronrod-x-wgs.lua.in",
          ["lgsl.templates.lmfit"] = "lgsl/templates/lmfit.lua.in",
          ["lgsl.templates.ode-defs"] = "lgsl/templates/ode-defs.lua.in",
          ["lgsl.templates.qag"] = "lgsl/templates/qag.lua.in",
          ["lgsl.templates.qng"] = "lgsl/templates/qng.lua.in",
          ["lgsl.templates.rk4"] = "lgsl/templates/rk4.lua.in",
          ["lgsl.templates.rk8pd"] = "lgsl/templates/rk8pd.lua.in",
          ["lgsl.templates.rkf45"] = "lgsl/templates/rkf45.lua.in",
          ["lgsl.templates.rkf45vec"] = "lgsl/templates/rkf45vec.lua.in",
          ["lgsl.templates.rnd-defs"] = "lgsl/templates/rnd-defs.lua.in",
          ["lgsl.templates.sf-defs"] = "lgsl/templates/sf-defs.lua.in",
          ["lgsl.templates.vegas-defs"] = "lgsl/templates/vegas-defs.lua.in",
          -- demos
          ["lgsl.demos.anim"] = "demos/anim.lua",
          ["lgsl.demos.bspline"] = "demos/bspline.lua",
          ["lgsl.demos.demos"] = "demos/demos.lua",
          ["lgsl.demos.fft"] = "demos/fft.lua",
          ["lgsl.demos.fractals"] = "demos/fractals.lua",
          ["lgsl.demos.integ"] = "demos/integ.lua",
          ["lgsl.demos.linfit"] = "demos/linfit.lua",
          ["lgsl.demos.nlinfit"] = "demos/nlinfit.lua",
          ["lgsl.demos.ode"] = "demos/ode.lua",
          ["lgsl.demos.plot"] = "demos/plot.lua",
          ["lgsl.demos.roots"] = "demos/roots.lua",
          ["lgsl.demos.sf"] = "demos/sf.lua",
          ["lgsl.demos.vegas"] = "demos/vegas.lua",
          ["lgsl.demos.wave-particle"] = "demos/wave-particle.lua",
      },
   },
   copy_directories = { "tests", "doc" },
}
