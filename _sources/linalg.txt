.. highlight:: lua

.. currentmodule:: matrix

Linear Algebra
==============

Functions
---------

LGSL gives access to linear algebra functions based on GSL itself or on the BLAS routines.

.. function:: inv(m)

   Returns the inverse of the matrix :math:`m`.

.. function:: det(m)

   This function computes the determinant of a matrix :math:`m` from its LU decomposition, :math:`L U`.
   The determinant is internally computed as the product of the diagonal elements of :math:`U` and the sign of the row permutation signum.

.. function:: solve(A, b)

   Solve the square system :math: `A x = b` where :math:`A` is a square matrix, :math:`b`
   is a column matrix. It returns the solution :math:`x` of the system.

.. function:: svd(m)

   A general rectangular M-by-N matrix :math:`A` has a singular value
   decomposition (SVD) into the product of an M-by-N orthogonal matrix :math:`U`,
   an N-by-N diagonal matrix of singular values :math:`S` and the transpose of an
   N-by-N orthogonal square matrix :math:`V`,

   .. math::
     A = U S V^T

   The singular values :math:`\sigma_i= S_{ii}`
   are all non-negative and are
   generally chosen to form a non-increasing sequence
   :math:`\sigma_1 \geq \sigma_2 \geq ... \geq \sigma_N \geq 0`.

   The singular value decomposition of a matrix has many practical uses.
   The condition number of the matrix is given by the ratio of the largest
   singular value to the smallest singular value. The presence of a zero
   singular value indicates that the matrix is singular. The number of
   non-zero singular values indicates the rank of the matrix.  In practice
   singular value decomposition of a rank-deficient matrix will not produce
   exact zeroes for singular values, due to finite numerical precision.
   Small singular values should be edited by choosing a suitable tolerance.

   For a rank-deficient matrix, the null space of :math:`A` is given by the
   columns of :math:`V` corresponding to the zero singular values.  Similarly, the
   range of :math:`A` is given by columns of U corresponding to the non-zero
   singular values.

   Note that the routines here compute the "thin" version of the SVD
   with :math:`U` as M-by-N orthogonal matrix. This allows in-place computation
   and is the most commonly-used form in practice.  Mathematically, the
   "full" SVD is defined with :math:`U` as an M-by-M orthogonal matrix and :math:`S` as an
   M-by-N diagonal matrix (with additional rows of zeros).

   This function returns three values, in the order, :math:`U`, :math:`S`, :math:`V`. So you can
   write something like this::

      U, S, V = matrix.svd(m)

.. function:: lu(m)

   This function factorizes the square matrix :math:`A` into the LU decomposition :math:`PA = LU`::
      
      L, U = matrix.lu(m)

.. function:: qr(m)

   This function factorizes the M-by-N matrix :math:`A` into the QR decomposition :math:`A = Q R`::
   
      Q, R = matrix.qr(m)

.. function:: cholesky(m)

   A symmetric, positive definite square matrix :math:`A` has a Cholesky decomposition into a product of a
   lower triangular matrix :math:`L` and its transpose :math:`L^T`,

   real: :math:`A = L L^T`

   complex: :math:`A = L L^\star`

   This is sometimes referred to as taking the square-root of a matrix.
   The Cholesky decomposition can only be carried out when all the eigenvalues of the matrix are positive.
   This decomposition can be used to convert the linear system :math:`A x = b` into a pair of triangular systems (:math:`L y = b, L^T x = y`),
   which can be solved by forward and back-substitution.

   This function factorizes the symmetric, positive-definite square matrix :math:`A` into the Cholesky decomposition::

     L, LT = matrix.cholesky(A) 

   On input, the values from the diagonal and lower-triangular part of the matrix :math:`A` are used (the upper triangular part is ignored).
   If the matrix is not positive-definite then the decomposition will fail. 


.. function:: td_decomp(m)

   A matrix :math:`A` can be factorized by similarity transformations into the form,

   real: :math:`A = Q T Q^T`

   complex: :math:`A = U T U^T`

   where

   real: :math:`Q` is an orthogonal matrix and :math:`T` is a symmetric tridiagonal matrix.

   complex: :math:`U` is a unitary matrix and :math:`T` is a real symmetric tridiagonal matrix.

   This function calculates this decomposition and returns :math:`Q` or `U`, the diagonal vector and the sub-diagonal vector::
   
     Q, Tdiag, Tsdiag = matrix.td_decomp(m)

.. function:: hessenberg_decomp(m)

   A general real matrix :math:`A` can be decomposed by orthogonal similarity transformations into the form

   :math:`A = U H U^T`

   where :math:`U` is orthogonal and :math:`H` is an upper Hessenberg matrix, meaning that it has zeros below the first subdiagonal.
   The Hessenberg reduction is the first step in the Schur decomposition for the nonsymmetric eigenvalue problem,
   but has applications in other areas as well.
   The function returns ``H`` and ``U``::
  
      H, U = matrix.hessenberg_decomp(m)

.. function:: hesstri_decomp(a,b)

   A general real matrix pair :math:`(A, B)` can be decomposed by orthogonal similarity transformations into the form

     A = U H V^T
     B = U R V^T

   where U and V are orthogonal, H is an upper Hessenberg matrix, and R is upper triangular.
   The Hessenberg-Triangular reduction is the first step in the generalized Schur decomposition for the generalized eigenvalue problem.
   The function returns H, R, U and V::
   
      H, R, U, V = matrix.hesstri_decomp(m)
