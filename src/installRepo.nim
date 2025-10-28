import os, strutils
import addRepo, help, installPkg, pkgFromUrl, vars

proc installRepo*(url: string, tag: string = "HEAD") =
  var pkg: string = pkgFromUrl(url)
  installPkg(url, tag)
  echo addRepo(url)
