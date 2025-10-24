import osproc, strutils
import addRepo

proc addRepoPkg*(param: string) =
  var file: string
  if param.startsWith("http"):
    file = execProcess("curl " & param)
    for line in lines(param):
      file = file & "\n" & line
  else:
    for line in lines(param):
      file = file & "\n" & line

  for line in file.splitLines():
    discard addRepo(line)
