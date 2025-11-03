import os, osproc, strutils, terminal
import help, pkgFromUrl, runLoading, vars

proc removePkg*(pkg: string, tag: string = "HEAD") =
  var installedDirs: seq[string] = @[]
  var mainInstalledDir = pkgsDir / pkg
  installedDirs.add(mainInstalledDir)

  let previousDir = getCurrentDir()
  let srcDir = buildDir & "/" & pkg & "/" & tag
  let installDir = pkgsDir & "/" & pkg & "/" & tag
  if dirExists(pkgsDir / pkg):

    removeDir(srcDir)

    var pkgUrl: string
    var matches: seq[string] = @[]
    for line in lines(reposDir & "/repos"):
      if line.contains(pkg):
        matches.add(line)
    if matches.len > 1:
      for i, match in matches:
        echo yellow & $i & ":\t" & green & match & colorReset
      stdout.write("Select the package you'd like to remove (Default: 0): ")
      let answerStr = readLine(stdin)
      var answer: int
      if answerStr.len == 0:
        answer = 0
      else:
        answer = parseInt(answerStr)
      pkgUrl = matches[answer]
    else:
      pkgUrl = matches[0]

    for item in walkDirRec(buildDir):
      if item.endsWith("pkgdeps"):
        try:
          if pkgUrl in readFile(item):
            echoPkgit()
            echo error & "Package is a dependency of " & extractFileName(parentDir(parentDir(item)))
            quit(1)
        except:
          continue

    let repos = reposDir & "/repos"
    for line in lines(repos):
      if line.strip().toLower.contains("/" & pkg):
        pkgUrl = line

    if tag == "HEAD":
      var cloneMsg = execProcess("git -c advice.detachedHead=false clone --depth 1 " & pkgUrl & " " & srcDir)
      if cloneMsg.contains("fatal"):
        echoPkgit()
        echo error & "Could not clone repository: " & pkgUrl
        quit(1)
    else:
      var cloneMsg = execProcess("git -c advice.detachedHead=false clone --branch " & tag & " --depth 1 " & pkgUrl & " " & srcDir)
      if cloneMsg.contains("fatal"):
        echoPkgit()
        echo error & "Could not clone repository: " & pkgUrl
        quit(1)

    setCurrentDir(srcDir)
    if fileExists("pkgdeps"):
      var deps: seq[string] = @[]
      for url in lines("pkgdeps"):
        var repo: string
        if url.contains(" "):
          let tag = url.split(" ", 1)[1]
          repo = url.split(" ", 1)[0]
          deps.add(repo)
        else:
          repo = url
          deps.add(repo)
      for repo in deps:
        echo repo
      echoPkgit()
      stdout.write "Do you want to remove these dependencies? [y/N]: "
      var answer = readLine(stdin).toLower
      stdout.write "\n"
      if answer == "y":
        for repo in deps:
          installedDirs.add(pkgsDir / pkgFromUrl(repo))
    elif fileExists(depsDir / pkg & ".pkgdeps"):
      var deps: seq[string] = @[]
      for url in lines(depsDir / pkg & ".pkgdeps"):
        var repo: string
        if url.contains(" "):
          let tag = url.split(" ", 1)[1]
          repo = url.split(" ", 1)[0]
          deps.add(repo)
        else:
          repo = url
          deps.add(repo)
      for repo in deps:
        echo repo
      echoPkgit()
      stdout.write "Do you want to remove these dependencies? [y/N]: "
      var answer = readLine(stdin).toLower
      stdout.write "\n"
      if answer == "y":
        for repo in deps:
          installedDirs.add(pkgsDir / pkgFromUrl(repo))
    setCurrentDir(previousDir)

    for installedDir in installedDirs:
      let installedDirCopy = installedDir
      let pkgName = installedDirCopy.splitPath().tail
      stdout.write blue & "Removing symlinks "
      runLoading(proc() = 
        if fileExists(appDir / pkg.splitPath().tail & ".desktop"):
          removeFile(appDir / pkg.splitPath().tail & ".desktop")
        for file in walkDirRec(installedDirCopy):
          removeFile(binDir / file.splitPath().tail)
          removeDir(buildDir / file.splitPath().tail)
      )

      eraseLine()
      echoPkgit()
      echo success & "Removed symlinks"

      stdout.write blue & "Removing package "
      runLoading(proc() = removeDir(installedDirCopy))

      eraseLine()
      stdout.write colorReset
      echoPkgit()
      echo success & "Package removed:\t" & green & pkgName & colorReset
  else:
    echoPkgit()
    echo error & pkg & " is not installed!"
