# LGSL: A numerical library for Lua based on GSL

* Copyright (C) 2009-2016 Francesco Abbate, Lesley De Cruz and Benjamin von Ardenne
* Published under GPL-3

## About

LGSL is a collection of numerical algorithms and functions for Lua, based on
the GNU Scientific Library (GSL). It allows matrix/vector manipulation and
linear algebra operations.

LGSL is not just a wrapper over the C API of GSL but offers a much more simple
and expressive way to use GSL. The objective of LGSL is to give the user the
power to easily access GSL functions without having to write a complete C
application.

LGSL is based on the numerical modules of [GSL
Shell](http://www.nongnu.org/gsl-shell/).

## Requirements

* [LuaJIT 2.0.3](http://luajit.org) or higher.
* [GSL 1.14](http://www.gnu.org/software/gsl/) or higher.
* [graph-toolkit](http://github.com/franko/graph-toolkit) is recommended to
  create plots, and required to run the demos.

## Usage

See the [LGSL Documentation](http://lgsl.duckdns.org/).

To see some demos, fire up LuaJIT and type:

``` lua
require("lgsl.demos").run()
```

# Installation Instructions

LGSL is implemented as a set of Lua files and depends on LuaJIT (version 2.0 or
higher) and on the GSL library (version 1.14 or higher).  As the implementation
is in Lua, no compilation is needed.

The recommended way to install and update LGSL is with LuaRocks. To install the
latest development version, run:

```
luarocks install --server=http://luarocks.org/dev lgsl 
```

The standard method to install LGSL without LuaRocks is to type `make install`
from the source directory.  The command will install all the required files in
a system-wide directory in the package search path of Lua and requires sudo
privileges.  Before installing you may change the `PREFIX` directory in
`Makefile` or with `make install PREFIX=/path/to/install`.

On Debian-based systems like Ubuntu or Debian itself, the package can be
installed from a Debian package.  The command `make debian` or simply `make`
will build a Debian package in the source code directory.  Once the package is
created, it can be installed with sudo privileges using the command:

```
sudo dpkg -i name-of-debian-package
```

## Dependencies

LGSL currently requires LuaJIT 2.0 or later to run. It is recommended to
install the latest version of LuaJIT. Installation instructions for LuaJIT can
be found on the [LuaJIT website](http://luajit.org/install.html).

The short version (on POSIX systems):

```
git clone http://luajit.org/git/luajit-2.0.git
cd luajit-2.0
make && sudo make install
```

On most Linux distributions, the GSL library can be installed through your
system package manager.

On Debian and derived distributions such as Ubuntu:
```
sudo apt-get install libgsl0ldbl
``` 

On Red Hat and family, e.g. CentOS:
```
sudo yum install gsl.x86_64
```

On Arch Linux:
```
sudo pacman -S gsl
```

Other installation options can be found on the [GSL
website](http://www.gnu.org/software/gsl/).

## Recommended Packages

If you want to create plots or run the demos, you are advised to install the
Lua Graphics Toolkit:

```
luarocks install --server=http://luarocks.org/dev graph-toolkit
```

More information can be found at graph-toolkit's [GitHub
page](https://github.com/franko/graph-toolkit) and the
[documentation](http://franko.github.io/graph-toolkit).

## Manual Installation

To manually install the package, the `lgsl` directory should be copied into a
directory included in the standard Lua search path such as `/usr/share/lua/5.1/`.
The files included in `lgsl/templates` should be included as well by copying them
in a subdirectory named `templates`.

