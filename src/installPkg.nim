import os, osproc, strutils
import buildPkg, getDeps, help, pkgFromUrl, vars

proc installPkg*(pkgCall: string, tag: string = "HEAD") =
  var pkg: string
  var url: string
  if pkgCall.startsWith("http"):
    url = pkgCall
    pkg = pkgFromUrl(pkgCall)
  else:
    pkg = pkgCall.toLower()

  let repos: string = reposDir & "/repos"
  var pkgFound: bool = false
  var alreadyInstalled: bool = false
  var matches: int = 0
  if url == "":
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
  else:
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
    echo red & "[ERROR] " & colorReset & pkg & " is not in your repos!"
    quit(1)

