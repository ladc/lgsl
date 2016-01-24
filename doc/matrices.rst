.. highlight:: lua

Matrices
========

Overview
--------

LGSL's main data types are *real* and *complex* matrices and many of the GSL routines work on these data types.
LGSL does not have a separate type to represent a vector; instead, column matrices are used for this purpose.

With :mod:`matrix` you can do basic arithmetic operations with the usual mathematical meaning provided that the dimensions of the matrices are compatible.
You can also freely mix scalars with matrices, LGSL will perform the appropriate operation in each case. 
In general you can also mix real and complex valued numbers or matrices in arithmetic operations and the result will be complex if at least one of the operands is complex.
The only arithmetic operation that is not allowed is the division where the right operand is a matrix.
The reason is that this operation does not have a well-defined mathematical meaning.
In general the inversion of a matrix can be performed using the function :func:`matrix.inv` or the function :func:`matrix.solve` to solve a linear system efficiently.

In general most of the matrix-related functions can operate on both real or complex matrices and return the appropriate result.

In order to create a new matrix you should use the :func:`matrix.new` function to define a *real* matrix and :func:`matrix.cnew` for a *complex* matrix. If you want to create a matrix by explicitly listing all of its elements you can instead use the function :func:`matrix.def`, or :func:`matrix.vec` in the case of a vector (column matrix).

The :func:`matrix.new` function takes two mandatory arguments, the number of rows and the number of columns, and an optional third argument. If the third argument is not given, all the elements of the matrix are initialized to zero. Otherwise, if you provide a function of two variables, let's say i and j, it will be used to initialize the elements of the matrix. The provided function will be called for each element of the matrix with the index of row and column as an argument. This provides a very useful way to initialize matrices. As an example, let us suppose that we want to define a matrix ``m`` of dimension :math:`n \times n` whose elements are given by :math:`m_{jk} = \textrm{exp} (2 \pi i j k / n)`.

Using LGSL, we can define the matrix with the following command::

   matrix = require("lgsl.matrix")

   n = 4

   -- we define a complex matrix that operates a Fourier transform
   m = matrix.cnew(n, n, function(j,k) return complex.exp(2i*math.pi*(j-1)*(k-1)/n) end)

where you have previously defined ``n`` to be a small integer number.

Accessing Matrix Elements
-------------------------

To access an element of a matrix placed at the i-th row and the j-th column you can either index the matrix as you would a Lua table, ``m[i][j]``, or use the syntax ``m:get(i, j)``, where ``m`` is the matrix. 
You can also change the value with the following syntax ``m:set(i, j, x)`` to set the element to the value ``x``.

In LGSL's indexing convention the first row or column of a matrix in identified by the number one.
This is the same indexing convention used in FORTRAN and also in standard mathematical notation and is also coherent with the Lua indexing of a table.

In LGSL, matrices with only one column are considered as vectors, and you can reference their elements just by indexing the vector like in ``v[i]``.
You can therefore read or set a specific element of a vector using
simple indexing as illustrated in the following example::

  >>> -- we define a vector, it is just a matrix with one column
  >>> v = matrix.vec {0, 0.2, 0.4, 7.6, 0.8, 1.0}

  >>> =v
  [ 0   ]
  [ 0.2 ]
  [ 0.4 ]
  [ 7.6 ]
  [ 0.8 ]
  [ 1   ]

  >>> =v[4]
  7.6

  >>> v[4] = 0

  >>> =v[4]
  0

If you index a matrix with more than one column, you will obtain a row of the matrix, but in column form.
The resulting column matrix will refer to the same underlying data of the original matrix.
Since the two matrices refer to the same data, any change to the content of one matrix will affect both of them.

Here are some simple examples of matrix manipulations::

   >>> m = matrix.def {{0.2, 4, -0.5}, {2, 0, 1.1}}

   >>> =m
   [  0.2    4 -0.5 ]
   [    2    0  1.1 ]

   >>> =m[1]
   [  0.2 ]
   [    4 ]
   [ -0.5 ]

   >>> -- we change one of the matrix elements
   >>> m[1][2] = -0.7

   >>> =m
   [  0.2 -0.7 -0.5 ]
   [    2    0  1.1 ]

In general, the aliasing between matrices can be useful in many circumstances to refer to an original matrix by using a submatrix.
In case you really need a submatrix which is an independent copy of its parent matrix you can just use the :func:`matrix.copy` function to obtain a copy.

You may have noticed that when you index a matrix with multiple columns, you obtain the row corresponding to the index, but in column form.
If you want to obtain a row in the form of a row matrix, you can use the :meth:`~Matrix.row` method.
Alternatively, you can use the :meth:`~Matrix.slice` method that lets you extract any submatrix of contiguous rows and columns.

.. note:: 
  It is possible to index a matrix as you would a Lua table in order to access or modify matrix elements, as shown above. However, in performance-sensitive situations, such as an inner loop, it is advised to use the :meth:`~Matrix.set` and :meth:`~Matrix.get` methods, which are faster.

Matrix Dimensions
~~~~~~~~~~~~~~~~~

To obtain the dimension of a matrix you should use the :meth:`~Matrix.dim` method that returns the number of rows and columns of a matrix. Here an example::

   -- we define a matrix
   m = matrix.def {{0.2, 4, -0.5}, {2, 0, 1.1}}

   -- we obtain the number of rows and columns, r and c respectively
   r, c = m:dim()

.. note::

  You can also use the length operator ``#`` with a matrix to obtain just the number of rows.

Matrix methods
--------------

.. class:: Matrix

  .. method:: copy()

     Return a copy of the matrix.

  .. method:: dim()

     Return the dimensions of the matrix, i.e. the numbers of rows and the number of columns, in that order.

  .. method:: rows()

     Return the number of rows of the matrix.

  .. method:: cols()

     Return the number of columns of the matrix.

  .. method:: get(i, j)

     This function returns the ``(i,j)``-th element of a matrix. As a general
     convention in LGSL the index of the first element is 1.

  .. method:: set(i, j, v)

     This function sets the value of the ``(i,j)``-th element of the matrix to ``v``.

  .. method:: slice(k0, k1, n0, n1)

     Return a sub-matrix obtained from the original matrix by starting
     at the element (k0, k1) and taking n0 rows and n1 columns. The
     matrix that is returned is a "view" of the existing matrix in the
     sense that it makes reference to the same underlying matrix. So if
     you modify the submatrix you will implicitly modify the original
     matrix and vice versa.

  .. method:: norm()

     Return the Frobenius norm of the matrix. It is defined as:

     .. math::
        \|a\| = \sqrt{\sum_i \sum_j | a_{ij} |^2}

     where a\ :sub:`ij` are the elements of the matrix.

  .. method:: row(i)

     Return the submatrix given by the i-th row of the matrix.

  .. method:: col(j)

     Return the submatrix given by the j-th column of the matrix.

Matrix Functions
----------------

.. module:: matrix

All the functions described in this section have an equivalent function for complex valued matrices. The functions for complex matrices are obtained by adding the 'c' prefix to the name. So for example the function :func:`mul` has an equivalent for complex matrix whose name is :func:`cmul`.

.. function:: new(r, c[, finit])

   Returns a new matrix of ``r`` rows and ``c`` columns. If ``finit``
   is not given, the matrix is initialized to 0. If ``finit`` is
   provided, the function ``finit(i, j)`` is called for all the
   elements, with the i arguments equal to the row index and j equal to
   the column index. Then the value returned by the function is assigned
   to the matrix elements.

.. function:: cnew(r, c[, finit])

   Returns a new complex matrix. The meaning of its arguments is the
   same of the function :func:`new`.

.. function:: def(t)

    Convert the table ``t`` into a matrix. The table should be in the form ``{{row1_v1, row1_v2, ...}, {row2_v1, row2_v2, ...}, ...}`` where each term is a number. You should also ensure that all the lines contain the same number of elements. Example::

      th = math.pi/6
      -- create a 2x2 rotation matrix using the angle th
      m = matrix.def {{math.cos(th), math.sin(th)}, {-math.sin(th), math.cos(th)}}

.. function:: vec(t)

    Convert the table ``t`` into a column matrix. In LGSL, column matrices are considered vectors. The table should be in the form ``{v1, v2, v3, ...}``.

.. function:: stack(layout)

    Returns a new matrix by stacking together, horizontally and vertically, more matrices as specified in the ``layout`` argument.

    The argument ``layout`` should be in the form ``{{A1, A2, ...}, {B1, B2, ...}, ...}`` to indicate the layout of the matrices to be composed.
    Each of the layout terms can be a matrix or a scalar.
    If a scalar is given it will be transformed into a matrix of identical elements and whose dimensions will be adjusted to fit the other matrices in the layout.

.. function:: dim(m)

   Returns two values: the number of rows and the number of columns of the matrix, in that order.

.. function:: copy(m)

   Returns a copy of the matrix.

.. function:: transpose(m)

   Return the transpose of the matrix.

.. function:: hc(m)

   Return the hermitian conjugate of the matrix.

.. function:: diag(t)

   Given a table or column vector ``t`` of length ``n``, returns a diagonal matrix whose diagonal elements are equal to the elements of ``t``.

.. function:: unit(n)

   Return the unit matrix of dimension nxn.

.. function:: set(a, b)

   Set the matrix ``a`` to be equal to the matrix ``b``. It raises an
   error if the dimensions of the matrices are different. Please note
   that it is different than the statement::

     a = b

   because the latter simply makes the variable ``a`` refer to the
   same matrix as ``b``. With the :func:`set` function, you set each
   element of an existing matrix ``a`` to the same value as the
   corresponding element of ``b``.

.. function:: fset(m, f)

   Set the elements of the matrix ``m`` to the value given by
   ``f(i, j)`` where ``i`` and ``j`` are, respectively, the row and column
   indices of the matrix. Note that this function has the same
   semantics as the :func:`new` function with the difference that :func:`fset`
   operates on a matrix that already exists instead of creating a new one.
