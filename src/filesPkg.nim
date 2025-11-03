import os
import help, vars

proc filesPkg*(pkg: string) =
  for item in walkDirRec(pkgsDir / pkg):
    if dirExists(item):
      if item.splitPath().tail == "include":
        for file in walkDirRec(absolutePath(includeDir / pkg)):
          if fileExists(file) and fileExists(item):
            echo absolutePath(file)
      elif item.splitPath().tail == "bin":
        for file in walkDirRec(absolutePath(binDir)):
          if fileExists(file) and fileExists(item):
            echo absolutePath(file)
      elif item.splitPath().tail == "lib":
        for file in walkDirRec(absolutePath(libDir / pkg)):
          if fileExists(file) and fileExists(item):
            echo absolutePath(file)
      else:
        continue
    elif fileExists(item):
      echo absolutePath(item)
    else:
      echoPkgit()
      echo error & pkg & " is not installed!"
