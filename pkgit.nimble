# Package

version       = "0.1.0"
author        = "dacctal"
description   = "unconventional package manager"
license       = "GPL-3.0-or-later"
srcDir        = "src"
bin           = @["pkgit"]


# Dependencies

requires "nim >= 2.2.4"

requires "parsetoml >= 0.7.2"
