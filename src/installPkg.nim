import os, osproc, strutils
import buildPkg, getDeps, help, vars

proc installPkg*(pkgCall: string) =
  var tag: string
  var pkg: string
  if pkgCall.contains(":"):
    pkg = pkgCall.split(':', 1)[0].toLower()
    tag = pkgCall.split(':', 1)[1]
  else:
    pkg = pkgCall.toLower()
    tag = "HEAD"

  let repos: string = reposDir & "/repos"
  var pkgFound: bool = false
  var url: string
  var alreadyInstalled: bool = false
  var matches: int = 0
  for line in lines(repos):
    if line.strip().toLower().contains("/" & pkg):
      matches += 1
      if dirExists(pkgsDir & "/" & pkg & "/" & tag):
        echoPkgit()
        echo pkg & ":" & tag & " already installed!"
        pkgFound = true
        alreadyInstalled = true
      else:
        url = line & ".git"
        pkgFound = true

  if pkgFound:
    if not alreadyInstalled:
      let previousDir = getCurrentDir()
      let srcDir = buildDir & "/" & pkg & "/" & tag
      let installDir = pkgsDir & "/" & pkg & "/" & tag
      removeDir(srcDir)

      if tag == "HEAD":
        var cloneMsg = execProcess("git -c advice.detachedHead=false clone --depth 1 " & url & " " & srcDir)
        if cloneMsg.contains("fatal"):
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Could not clone repository: " & url
          quit(1)
      else:
        var cloneMsg = execProcess("git -c advice.detachedHead=false clone --branch " & tag & " --depth 1 " & url & " " & srcDir)
        if cloneMsg.contains("fatal"):
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Could not clone repository: " & url
          quit(1)

      setCurrentDir(srcDir)
      getDeps(pkg)
      setCurrentDir(previousDir)
      buildPkg(url, tag)
  else:
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Package is not in your repos!"
    quit(1)

