.. highlight:: lua

.. _gsl-ffi-interface:

GSL FFI interface
=================

In this chapter we are going to explain the direct GSL interface to use the C functions provided by the GSL library directly.

Introduction
~~~~~~~~~~~~

The access to the C GSL functions is possible thanks to the FFI library provided by LuaJIT.
The FFI module allows one to call any C function available from the dynamic libraries currently loaded, directly from Lua code.

Some of the modules available in LGSL are reimplemented in Lua using the FFI interface and the basic GSL functions for BLAS and linear algebra.

For example, the module for non-linear fitting has been completely reimplemented in Lua using the FFI interface.
Thanks to the capability of LuaJIT to generate highly optimized code on the fly, the Lua implementation runs at a speed comparable to compiled optimized C code.
For the ODE systems LuaJIT is in general comparable to C in terms of speed.
Another module re-implemented in Lua is the module for numerical integration, where the QAG adaptive routine has been ported with excellent results.

The non-linear fit module reimplemented in Lua has been checked for correctness using a subset of the `NIST datasets <http://www.itl.nist.gov/div898/strd/nls/nls_main.shtml>`_.

You can run the tests yourself by giving the following command.

.. todo::
   Add NIST tests; add comparison between C and LGSL versions of VEGAS and root finders.
 
Then you can compare the results and the plots to the official results published in the NIST website.

Here is an example of the plot produced for the ENSO dataset:

.. figure:: lmfit-enso-dataset-plot.png

GSL FFI interface
~~~~~~~~~~~~~~~~~

.. module:: gsl

The usage of the GSL FFI interface is done using the :mod:`gsl` module.
This module contains all the GSL functions available and you can call them directly from Lua code.
Because direct usage of the GSL functions is considered "expert mode", the :mod:`gsl` module is not loaded by default when requiring the parent module :mod:`lgsl`.

Let us see a simple example::

   -- we load the gsl module
   gsl = require("lgsl.gsl")
   matrix = require("lgsl.matrix")

   -- we define a new matrix
   m = matrix.new(4, 4)

   for i = 0, 3 do
     for j = 0, 3 do
       gsl.gsl_matrix_set(m, i, j, 1/(i+j+1))
     end
   end

As you can see we are just using the GSL function :func:`gsl_matrix_set` to set the value each of element of the matrix.

There are a few things that are important to note.
The C function that we have used has the following signature ``void gsl_matrix_set(gsl_matrix *m, int i, int j, double x)``.
When you call it from Lua, the arguments are converted to the appropriate C types using a set of rules specific to the `FFI semantics <http://luajit.org/ext_ffi_semantics.html>`_.
The implementation of LGSL ensures that a matrix object can actually be converted to a ``gsl_matrix`` pointer.
As for the other arguments, note that the Lua numbers are converted to integer or double as appropriate to match the C function signature.
If the arguments cannot be converted to the appropriate type, an error is raised.

Another thing that you may note is that we have ignored the value returned by the GSL function.
In general, the return value can signal an error condition and it could be necessary to check the returned value.
For this purpose, LGSL offers a simple helper function in :mod:`gsl-check`. We illustrate its usage by continuing upon the previous example::

  gsl_check = require("lgsl.gsl-check")

  gsl_check(gsl.gsl_matrix_add(m,m)) -- this should pass
  gsl_check(gsl.gsl_matrix_add(m,matrix.new(2,2))) -- this should raise an error

The function :func:`gsl_check` above just checks the returned value of the :func:`gsl.gsl_matrix_add` call and raises an error with an appropriate message if needed. In the second call in the example above, it will generate the error: ``"ERROR: matrices must have same dimensions"``.

Finally note that the indexing convention when calling :func:`gsl.gsl_matrix_set` is the C convention where the first index is 0.
This fact is a direct implication of the fact that we are directly calling the C function defined in the GSL library.

GSL FFI examples
~~~~~~~~~~~~~~~~

If you want to learn more about the usage of the GSL FFI interface, you may take a look at the implementation file of the :mod:`bspline` module.

The file is quite small and easy to understand, and it illustrates all the important aspects of the GSL FFI interface.
