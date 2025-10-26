import os, strutils
import help, pkgFromUrl, searchPkgs, vars

proc removeRepo*(repo: string) =
  var matches: seq[string] = searchPkgs(repo)
  if matches.len > 0:
    for i, result in matches:
      let url = result.replace("@[\"", "").replace("\"]", "").toLower()
      let pkg = pkgFromUrl(result)
      if pkg.len < 7:
        echo yellow & $i & ":\t" & green & pkg & ":\t\t" & blue & url & colorReset
      else:
        echo yellow & $i & ":\t" & green & pkg & ":\t" & blue & url & colorReset
  else:
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "No matches found!"
    quit(1)

  stdout.write("Select the repo you'd like to remove (Default: 0): ")
  let answerStr = readLine(stdin)
  var answer: int
  if answerStr.len == 0:
    answer = 0
  else:
    answer = parseInt(answerStr)

  var scheduled: seq[string] = @[]
  for i, result in matches:
    if answer == i:
      scheduled.add(result)

  let repos: string = reposDir & "/repos"
  var kept: seq[string] = @[]
  for repo in scheduled:
    for line in lines(repos):
      if not line.contains(repo):
        kept.add(line)
      else:
        continue

  let file = open(repos, fmwrite)
  for repo in kept:
    file.writeLine(repo)
  file.close()
