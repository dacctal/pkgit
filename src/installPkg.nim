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
  var matches: seq[string] = @[]
  var matchesInstalled:seq[string] = @[]
  if url == "":
    for line in lines(repos):
      if line.strip().toLower().contains("/" & pkg):
        matches.add(line)
        if dirExists(pkgsDir & "/" & pkg & "/" & tag):
          matchesInstalled.add(line)
    if matches.len > 1:
      for i, match in matches:
        echo yellow & $i & ":\t" & green & match & colorReset
      echoPkgit()
      stdout.write("Select the package you'd like to install (Default: 0): ")
      let answerStr = readLine(stdin)
      var answer: int
      if answerStr.len == 0:
        answer = 0
      else:
        answer = parseInt(answerStr)
      url = matches[answer]
      echoPkgit()
      echo "Your choice: " & blue & matches[answer] & colorReset
      pkgFound = true
    else:
      url = matches[0]
      echo matches[0]
      echoPkgit()
      echo "Your choice: " & blue & matches[0] & colorReset
      pkgFound = true
    for match in matchesInstalled:
      if match.contains(url):
        echoPkgit()
        echo error & pkg & " --tag:" & tag & " already installed!"
        pkgFound = true
        alreadyInstalled = true
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

