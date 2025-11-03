import addRepo, installPkg, pkgFromUrl

proc installRepo*(url: string, tag: string = "HEAD") =
  var pkg: string = pkgFromUrl(url)
  installPkg(url, tag)
  echo addRepo(url)
