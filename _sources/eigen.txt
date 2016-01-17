.. highlight:: lua
.. module:: eigen

Eigensystems
=======================

This chapter describes functions for computing eigenvalues and eigenvectors of matrices.
There are routines for real symmetric, real nonsymmetric, complex hermitian, real generalized symmetric-definite, complex generalized hermitian-definite, and real generalized nonsymmetric eigensystems.
Eigenvalues can be computed with or without eigenvectors.
The hermitian and real symmetric matrix algorithms are symmetric bidiagonalization followed by QR reduction.
The nonsymmetric algorithm is the Francis QR double-shift. The generalized nonsymmetric algorithm is the QZ method due to Moler and Stewart.

Real Symmetric Matrices
---------------------------

.. function:: symm(A [, order])

   This function computes the eigenvalues and eigenvectors of the real symmetric matrix :math:`A`. The default ordering of the eigenvalues and eigenvectors is descending order in numerical value.
   You can however choose from the following sorting shemes for the eigenvalues:

   'desc'
      descending order in numerical value
   'asc'
      ascending order in numerical value
   'abs_asc'
      ascending order in magnitude
   'abs_desc'
      descending order in magnitude
   'none'
      eigenvalue sorting

   The function returns::

	  eval, evec = symm(A, 'abs_asc')

   while the first eigenvalue correpsonds to the first eigenvector stored in the first column of the eigenvectors matrix.
   For real symmetric matrices, the library uses the symmetric bidiagonalization and QR reduction method.
   This is described in Golub & van Loan, section 8.3. The computed eigenvalues are accurate to an absolute accuracy of :math:`\epsilon ||m||_2`, where :math:`\epsilon` is the machine precision.

Real Nonsymmetric Matrices
--------------------------

.. function:: non_symm(A [, order ] ])

   The solution of the real nonsymmetric eigensystem problem for a matrix :math:`A` involves computing the Schur decomposition

   :math:`A = Z T Z^T`

   where :math:`Z` is an orthogonal matrix of Schur vectors and :math:`T`, the Schur form, is quasi upper triangular with diagonal 1-by-1 blocks which are real eigenvalues of :math:`A`,
   and diagonal 2-by-2 blocks whose eigenvalues are complex conjugate eigenvalues of :math:`A`. The algorithm used is the double-shift Francis method.

   This function computes eigenvalues and right eigenvectors of the n-by-n real nonsymmetric matrix :math:`A`.
   The computed eigenvectors are normalized to have unit magnitude. On output, the upper portion of :math:`A` contains the Schur form :math:`T`::

      eval, evec, A = non_symm(A, 'abs_asc')


Complex Hermitian Matrices
----------------------------

.. function::herm(A [, order])

   For hermitian matrices, the library uses the complex form of the symmetric bidiagonalization and QR reduction method.
   This function computes the eigenvalues and eigenvectors of the complex hermitian matrix A

Real Generalized Symmetric-Definite Eigensystems
-------------------------------------------------

.. function:: gensymm(a, b)

   The real generalized symmetric-definite eigenvalue problem is to find eigenvalues :math:`\lambda` and eigenvectors :math:`x` such that

   .. math::
     A x = \lambda B x

   where :math:`A` and :math:`B` are symmetric matrices, and :math:`B` is positive-definite.
   This problem reduces to the standard symmetric eigenvalue problem by applying the Cholesky decomposition to :math:`B`:

   .. math::
                           A x = \lambda B x

                           A x = \lambda L L^t x

      ( L^{-1} A L^{-t} ) L^t x = \lambda L^t x

   Therefore, the problem becomes :math:`C y = \lambda y` where :math:`C = L^{-1} A L^{-t}` is symmetric, and :math:`y = L^t x`.
   The standard symmetric eigensolver can be applied to the matrix :math:`C`.
   The resulting eigenvectors are backtransformed to find the vectors of the original problem.
   The eigenvalues and eigenvectors of the generalized symmetric-definite eigenproblem are always real.

Complex Generalized Hermitian-Definite Eigensystems
------------------------------------------------------

.. function:: genherm(a, b)

   The complex generalized hermitian-definite eigenvalue problem is to find eigenvalues :math:`\lambda` and eigenvectors :math:`x` such that

   .. math::

      A x = \lambda B x

   where :math:`A` and :math:`B` are hermitian matrices, and :math:`B` is positive-definite.
   Similarly to the real case, this can be reduced to :math:`C y = \lambda y` where :math:`C = L^{-1} A L^{-H}` is hermitian,
   and :math:`y = L^H x`. The standard hermitian eigensolver can be applied to the matrix :math:`C`.
   The resulting eigenvectors are backtransformed to find the vectors of the original problem.
   The eigenvalues of the generalized hermitian-definite eigenproblem are always real.

Real Generalized Nonsymmetric Eigensystems
--------------------------------------------

.. function:: gen(a, b)

   Given two square matrices :math:`(A, B)`, the generalized nonsymmetric eigenvalue problem is to find eigenvalues :math:`\lambda` and eigenvectors :math:`x` such that

   .. math::

      A x = \lambda B x

   We may also define the problem as finding eigenvalues :math:`\mu` and eigenvectors :math:`y` such that

   .. math::

      \mu A y = B y

   Note that these two problems are equivalent (with :math:`\lambda = 1/\mu`) if neither :math:`\lambda` nor :math:`\mu` is zero. If say, :math:`\lambda` is zero, then it is still a well defined eigenproblem, but its alternate problem involving :math:`\mu` is not. Therefore, to allow for zero (and infinite) eigenvalues, the problem which is actually solved is

   .. math::

      \beta A x = \alpha B x

   The eigensolver routines below will return two values :math:`\alpha` and :math:`\beta` and leave it to the user
   to perform the divisions :math:`\lambda = \alpha / \beta` and :math:`\mu = \beta / \alpha`.

   If the determinant of the matrix pencil :math:`A - \lambda B` is zero for all :math:`\lambda`,
   the problem is said to be singular; otherwise it is called regular.
   Singularity normally leads to some :math:`\alpha = \beta = 0` which means the eigenproblem is ill-conditioned
   and generally does not have well defined eigenvalue solutions.
   The routines below are intended for regular matrix pencils and could yield unpredictable results when applied to singular pencils.

   The solution of the real generalized nonsymmetric eigensystem problem for a matrix pair :math:`(A, B)`
   involves computing the generalized Schur decomposition

   .. math::

      A = Q S Z^T

      B = Q T Z^T

   where :math:`Q` and :math:`Z` are orthogonal matrices of left and right Schur vectors respectively,
   and :math:`(S, T)` is the generalized Schur form whose diagonal elements give the :math:`\alpha` and :math:`\beta` values.
   The algorithm used is the QZ method due to Moler and Stewart (see references).

