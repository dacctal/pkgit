import os, strutils
import help, vars

proc listPkgs*() =
  var installedPkgs: seq[string] = @[]
  for dir in walkDir(pkgsDir):
    installedPkgs.add(dir.path.extractFileName)

  echoPkgit()
  echo "You have the following packages installed:"
  for pkg in installedPkgs:
    echo "\t" & green & pkg & colorReset
