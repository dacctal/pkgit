import os, osproc, strutils
import help, vars

proc setup*() = 
  for dir in essentialDirs:
    if not dirExists(dir):
      createDir(dir)

  let sysPath = getEnv("PATH")
  if not sysPath.contains(binDir):
    let bashrc = homeDir & "/.bashrc"
    let zshrc = homeDir & "/.zshrc"
    let fishrc = homeDir & "/.config/fish/config.fish"
    let nushrc = homeDir & "/.config/nushell/config.nu"
    if getEnv("SHELL").contains("bash"):
      if not readFile(bashrc).contains(binDir):
        let file = open(bashrc, fmappend)
        file.writeLine("PATH=$PATH:" & binDir)
        file.close()
        echoPkgit()
        echo yellow & "[WARNING] " & colorReset & "PATH modified, restart your shell!"
    elif getEnv("SHELL").contains("zsh"):
      if not readFile(zshrc).contains(binDir):
        let file = open(zshrc, fmappend)
        file.writeLine("PATH=$PATH:" & binDir)
        file.close()
        echoPkgit()
        echo yellow & "[WARNING] " & colorReset & "PATH modified, restart your shell!"
    elif getEnv("SHELL").contains("fish"):
      if not readFile(fishrc).contains(binDir):
        let file = open(zshrc, fmappend)
        file.writeLine("fish_add_path -aP " & binDir)
        file.close()
        echoPkgit()
        echo yellow & "[WARNING] " & colorReset & "PATH modified, restart your shell!"
    elif getEnv("SHELL").contains("nu"):
      if not readFile(nushrc).contains(binDir):
        let file = open(nushrc, fmappend)
        file.writeLine("use std/util \"path add\"")
        file.writeLine("path add \"" & binDir & "\"")
        file.close()
        echoPkgit()
        echo yellow & "[WARNING] " & colorReset & "PATH modified, restart your shell!"
