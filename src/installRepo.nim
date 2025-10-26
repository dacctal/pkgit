import os, strutils
import addRepo, help, installPkg, pkgFromUrl, vars

proc installRepo*(url: string, tag: string = "HEAD") =
  echo addRepo(url)
  var pkg: string = pkgFromUrl(url)
  installPkg(pkgFromUrl(pkg), tag)
