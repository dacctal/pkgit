import os, osproc, posix, strutils

proc needsRoot(): bool =
  when defined(posix):
    return getuid() != 0
  else:
    return false

proc ensureSu*() =
  var su: string
  if findExe("doas") != "":
    su = "doas"
  else:
    su = "sudo"

  if needsRoot():
    let args = commandLineParams()
    var cmd = su & " " & getAppFilename().extractFileName
    for arg in args:
      cmd.add(" " & quoteShell(arg))
    
    let exitCode = execCmd(cmd)
    quit(exitCode)
