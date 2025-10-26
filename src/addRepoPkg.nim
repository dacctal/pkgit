import osproc, strutils
import addRepo

proc addRepoPkg*(param: string) =
  var file: string
  if param.startsWith("http"):
    file = execProcess("curl -s " & param)
  else:
    for line in lines(param):
      file = file & "\n" & line

  for line in file.splitLines():
    if line == "":
      continue
    else:
      discard addRepo(line)
