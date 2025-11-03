import strutils
import vars

proc searchPkgs*(param: string): seq[string] =
  let repos: string = reposDir & "/repos"
  var matches: seq[string] = @[]
  for repo in lines(repos):
    if repo.toLower().contains(param):
      matches.add(repo)
    else:
      continue

  return matches
