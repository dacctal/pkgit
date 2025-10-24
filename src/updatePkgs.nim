import std/dirs, os, osproc, algorithm, strutils
import help, installPkg, pkgFromUrl, vars

proc updatePkgs*(): void =
  let repos = reposDir & "/repos"
  for url in lines(repos):
    let pkgBuilds = buildDir & "/" & pkgFromUrl(url)
    if dirExists(pkgBuilds):
      echoPkgit()
      echo "Updating:\t" & green & pkgFromUrl(url) & colorReset
      if fileExists(pkgBuilds & "/HEAD"):
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
        echo red & "[ERROR] " & colorReset & "No tags in repository"
      else:
        var tag = tags[0]
        tag = tag[(tag.rfind('/') + 1)..^1]
        if tag != getCurrentDir():
          installPkg(pkgFromUrl(url))
          echo ""
    else:
      continue

  echoPkgit()
  echo green & "[SUCCESS] " & colorReset & "Packages are up to date!"
