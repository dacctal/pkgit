import os, osproc, strutils
import vars, help

proc addRepo*(url: string): string =
  var tags: seq[string] = @[]
  let (output, status) = execCmdEx("git ls-remote --tags --refs " & url)
  if status == 0:
    for tag in execProcess("git ls-remote --tags --refs " & url).splitLines():
      tags.add(tag[(tag.rfind('/') + 1)..^1])
  else:
    echoPkgit()
    echo yellow & "[WARNING] " & colorReset & "Could not fetch tags from:\t" & url
    tags.add("HEAD")

  let latestTag: string = tags[^1]

  let repos: string = reposDir & "/repos"
  if not fileExists(repos):
    let file = open(repos, fmWrite)
    file.close()

  var found: bool = false
  for line in lines(repos):
    if line.strip().contains(url.replace(".git", "")):
      found = true
      echoPkgit()
      echo green & "[SKIPPED] " & colorReset & "Repo already exists: " & blue & url & colorReset
      break
  if not found:
    let file = open(repos, fmappend)
    file.writeLine(url.replace(".git", ""))
    echoPkgit()
    echo "Successfully added repo: " & url

  return latestTag
