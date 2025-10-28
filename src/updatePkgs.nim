import std/dirs, os, osproc, algorithm, strutils
import help, installPkg, pkgFromUrl, vars

proc updatePkgs*(): void =
  let repos = reposDir & "/repos"
  let prevDir = getCurrentDir()
  for url in lines(repos):
    if url == "":
      continue
    let pkgBuilds = buildDir & "/" & pkgFromUrl(url)
    if dirExists(pkgBuilds):
      if dirExists(pkgBuilds & "/HEAD"):
        setCurrentDir(pkgBuilds & "/HEAD")
      else:
        var versions: seq[string] = @[]
        for dir in walkDir(pkgBuilds):
          versions.add(dir.path.extractFileName)
        versions.sort()
        setCurrentDir(pkgBuilds & "/" & versions[0])
      var tags: seq[string] = execProcess("git ls-remote --tags --refs " & url).splitLines()
      if tags.len == 0:
        echoPkgit()
        echo error & "No tags in repository"
      else:
        var tag = tags[0]
        tag = tag[(tag.rfind('/') + 1)..^1]
        if tag != getCurrentDir() and not execProcess("git status").contains("up to date"):
          echoPkgit()
          echo "Updating:\t" & green & pkgFromUrl(url) & colorReset
          setCurrentDir(prevDir)
          installPkg(url)
          echo ""
        else:
          echoPkgit()
          echo green & "[SKIPPED]" & colorReset & " " & pkgFromUrl(url) & " is already up to date!"
    else:
      continue

  echo ""
  echoPkgit()
  echo green & "[SUCCESS] " & colorReset & "Packages are up to date!"
