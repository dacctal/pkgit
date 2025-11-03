import os, osproc, strutils
import help, installPkg, installRepo, vars

proc installList*(param: string) =
  var tag: string
  if fileExists(param):
    for line in lines(param):
      let lineParams = line.strip().split(" ")
      if lineParams[0].startsWith("http"):
        if execProcess("git ls-remote " & lineParams[0]).contains("fatal"):
          echoPkgit()
          echo error & "Repo doesn't exist: " & lineParams[0]
          continue
      if lineParams.len == 2:
        tag = lineParams[1]
      elif lineParams.len == 1:
        tag = "HEAD"
      else:
        echoPkgit()
        stdout.write error & "Line has too many parameters: " & blue
        for param in lineParams:
          stdout.write param & " "
        stdout.write colorReset & "\n"
        continue
      if lineParams[0].startsWith("http"):
        installRepo(lineParams[0], tag)
      else:
        installPkg(lineParams[0], tag)
  else:
    echoPkgit()
    echo error & "File doesn't exist!"
