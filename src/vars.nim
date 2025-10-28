import os, parsetoml, strutils

proc isUserLevel*(): bool =
  var configFile: File
  if fileExists("/etc/pkgit/config.toml"):
    try:
      let toml = parsefile("/etc/pkgit/config.toml")
      if toml["general"]["user-level"].getBool():
        return true
      elif not toml["general"]["user-level"].getBool():
        return false
    except:
      discard
  if fileExists(getEnv("HOME") & "/.config/pkgit/config.toml"):
    try:
      let toml = parsefile(getEnv("HOME") & "/.config/pkgit/config.toml")
      if toml["general"]["user-level"].getBool():
        return true
      elif not toml["general"]["user-level"].getBool():
        return false
    except:
      discard
  else:
    echo "You don't have a config file!"
    echo "Create one at either `~/.config/pkgit/config.toml` or `/etc/pkgit/config.toml`"
    echo "Add these lines:"
    echo "[general]"
    echo "user-level = true"
    #let isUserLevel = readLine(stdin)
    #if isUserLevel.contains('n'):
    #  let configDir: string = "/etc/pkgit"
    #  let config: string = configDir & "/config.toml"
    #  createDir(configDir)
    #  configFile = open(config, fmWrite)
    #  configFile.writeLine("[general]")
    #  configFile.writeLine("user-level = false")
    #  configFile.close()
    #  return false
    #else:
    #  let configDir: string = getEnv("HOME") & "/.config/pkgit"
    #  let config: string = configDir & "/config.toml"
    #  createDir(configDir)
    #  configFile = open(config, fmWrite)
    #  configFile.writeLine("[general]")
    #  configFile.writeLine("user-level = true")
    #  configFile.close()
    #  return true

let userLevelMode* = isUserLevel()

let
  homeDir*: string = getEnv("HOME")
  pkgitDir*: string = if userLevelMode: homeDir & "/.local/share/pkgit" else: "/var/pkgit"
  appDir*: string = if userLevelMode: homeDir & "/.local/share/applications" else: "/usr/share/applications"
  binDir*: string = if userLevelMode: homeDir & "/.local/share/bin" else: "/usr/bin"
  libDir*: string = if userLevelMode: homeDir & "/.local/share/lib" else: "/usr/lib"
  includeDir*: string = if userLevelMode: homeDir & "/.local/share/include" else: "/usr/include"
  pkgsDir*: string = pkgitDir & "/pkgs"
  buildDir*: string = pkgitDir & "/build"
  configDir*: string = if userLevelMode: homeDir & "/.config/pkgit" else: "/etc/pkgit"
  config*: string = configDir & "/config.toml"
  blditDir*: string = configDir & "/bldit"
  depsDir*: string = configDir & "/deps"
  reposDir*: string = configDir & "/repos"
  essentialDirs*: array[10, string] = [
    pkgitDir,
    appDir,
    binDir,
    libDir,
    includeDir,
    pkgsDir,
    buildDir,
    blditDir,
    depsDir,
    reposDir
  ]

const
  # version
  version*: string = "0.0.11-cleanup"

  # colors
  red*: string = "\e[0;31m"
  green*: string = "\e[0;32m"
  yellow*: string = "\e[0;33m"
  blue*: string = "\e[0;34m"
  magenta*: string = "\e[0;35m"
  cyan*: string = "\e[0;36m"
  gray*: string = "\e[0;37m"
  # bright
  brightRed*: string = "\e[0;91m"
  brightGreen*: string = "\e[0;92m"
  brightYellow*: string = "\e[0;93m"
  brightBlue*: string = "\e[0;94m"
  brightMagenta*: string = "\e[0;95m"
  brightCyan*: string = "\e[0;96m"
  brightGray*: string = "\e[0;97m"
  # bold
  boldRed*: string = "\e[1;31m"
  boldGreen*: string = "\e[1;32m"
  boldYellow*: string = "\e[1;33m"
  boldBlue*: string = "\e[1;34m"
  boldMagenta*: string = "\e[1;35m"
  boldCyan*: string = "\e[1;36m"
  boldGray*: string = "\e[1;37m"
  boldWhite*: string = "\e[1;38m"
  # bold bright
  boldBrightRed*: string = "\e[1;91m"
  boldBrightGreen*: string = "\e[1;92m"
  boldBrightYellow*: string = "\e[1;93m"
  boldBrightBlue*: string = "\e[1;94m"
  boldBrightMagenta*: string = "\e[1;95m"
  boldBrightCyan*: string = "\e[1;96m"
  boldBrightGray*: string = "\e[1;97m"
  # italic
  italic*: string = "\e[3m"
  # reset
  colorReset*: string = "\e[0m"

  # extra strings
  error*:string = red & "[ERROR]" & colorReset & " "
