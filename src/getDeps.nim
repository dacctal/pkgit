import os, strutils
import addRepo, help, buildPkg, pkgFromUrl, vars

proc getDeps*(pkgName: string) =
  if fileExists("pkgdeps"):
    for url in lines("pkgdeps"):
      if url.contains(" "):
        let tag = url.split(" ", 1)[1]
        discard addRepo(url.split(" ", 1)[0])
        let pkg = pkgFromUrl(url)
        if dirExists(pkgsDir & "/" & pkg & "/" & tag):
          echoPkgit()
          echo pkg & " already installed!"
          continue
        buildPkg(url.split(" ", 1)[0] & ":" & tag)
      else:
        discard addRepo(url)
        let pkg = pkgFromUrl(url)
        if dirExists(pkgsDir & "/" & pkg):
          echoPkgit()
          echo pkg & " already installed!"
          continue
        buildPkg(url)
  elif fileExists(depsDir / pkgName & ".pkgdeps"):
    for url in lines(depsDir / pkgName & ".pkgdeps"):
      if url.contains(" "):
        let tag = url.split(" ", 1)[1]
        discard addRepo(url.split(" ", 1)[0])
        let pkg = pkgFromUrl(url)
        if dirExists(pkgsDir & "/" & pkg & "/" & tag):
          echoPkgit()
          echo pkg & " already installed!"
          continue
        buildPkg(url.split(" ", 1)[0] & ":" & tag)
      else:
        discard addRepo(url)
        let pkg = pkgFromUrl(url)
        if dirExists(pkgsDir & "/" & pkg):
          echoPkgit()
          echo pkg & " already installed!"
          continue
        buildPkg(url)
