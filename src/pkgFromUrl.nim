import strutils

proc pkgFromUrl*(url: string): string = 
  var pkg = url[(url.rfind('/') + 1)..^1]
  if pkg.endsWith(".git"):
    pkg = pkg.replace(".git", "")

  return pkg.toLower()
