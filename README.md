# LGSL (WIP)

* Copyright (C) 2009-2015 Francesco Abbate
* Contributions by Benjamin von Ardenne and Lesley De Cruz
* Published under GNU GENERAL PUBLIC LICENSE, version 3

WARNING: This package is a work in progress and is not yet fully functional!

## About

LGSL is a collection of numeric algorithms and functions for Lua, based on the
GNU Scientific Library (GSL). It allows matrix/vector manipulation and linear
algebra operations. 

LGSL is not just a wrapper over the C API of GSL but offers a much more simple
and expressive way to use GSL. The objective of LGSL is to give the user the
power to easily access GSL functions without having to write a complete C
application.

LGSL is based on the numeric modules of [GSL Shell](http://www.nongnu.org/gsl-shell/).

## Requirements

* [LuaJIT 2.0.3](http://luajit.org) or higher.
* [GSL 1.14](http://www.gnu.org/software/gsl/) or higher.
* [graph-toolkit](http://github.com/franko/graph-toolkit) is required to run the demos.

## Usage

Please see the extensive [GSL Shell
documentation](http://www.nongnu.org/gsl-shell/doc/index.html) for now.

To see some examples, run `demos.lua` in the `demos` directory.

