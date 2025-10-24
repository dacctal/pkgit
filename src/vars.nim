import os

const
  # version
  version*: string = "0.0.4-beachdawn"

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

  # dirs
  homeDir*: string = getEnv("HOME")
  pkgitDir*: string = "/var/pkgit"
  # symlinks
  appDir*: string = "/usr" & "/share/applications"
  binDir*: string = "/usr" & "/bin"
  libDir*: string = "/usr" & "/lib"
  includeDir*: string = "/usr" & "/include"
  # install process
  pkgsDir*: string = pkgitDir & "/pkgs"
  buildDir*: string = pkgitDir & "/build"
  # configs
  configDir*:string = "/etc/pkgit"
  blditDir*: string = configDir & "/bldit"
  depsDir*: string = configDir & "/deps"
  reposDir*: string = configDir & "/repos"
  # altogether
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
