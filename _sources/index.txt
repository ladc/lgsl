##################################
Welcome to the LGSL documentation
##################################

LGSL is a collection of numerical algorithms and functions for `Lua`_, based on
the `GNU Scientific Library (GSL)`_. It allows matrix and vector manipulation,
linear algebra operations, special functions, and much more. LGSL is based on
the numerical modules of `GSL Shell`_, and aims to be an easy-to-include Lua
module with a focus on numerical algorithms.

LGSL offers an intuitive interface to the GSL functions, giving you easy access
to a well-tested scientific toolbox from your favourite Lua application. The
bindings to GSL were made with the FFI library of `LuaJIT`_. Thanks to LuaJIT, a
Just-In-Time compiler for Lua, scripts which use LGSL can run at speeds
comparable to optimized C code. A selection of functions were reimplemented in
Lua to get the most out of LuaJIT.

`LGSL on GitHub <https://github.com/ladc/lgsl/>`_

.. _Lua: http://www.lua.org
.. _GNU Scientific Library (GSL): http://www.gnu.org/software/gsl
.. _GSL Shell: http://www.nongnu.org/gsl-shell
.. _LuaJIT: http://luajit.org

Contents:

.. toctree::
   :maxdepth: 2

   intro.rst
   lua-base.rst
   complex.rst
   matrices.rst
   linalg.rst
   eigen.rst
   random.rst
   randist.rst
   pdf.rst
   linfit.rst
   nlinfit.rst
   bsplines.rst
   fft.rst
   ode.rst
   integ.rst
   vegas.rst
   sf.rst
   examples.rst
   gsl-ffi.rst
