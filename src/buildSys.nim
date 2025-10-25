import os, osproc, parsetoml, tables
import help, pkgFromUrl, vars

proc autogenBuild*(installDir: string, url: string, tag: string): int =
  discard execProcess("./autogen.sh")
  discard execProcess("make")
  return 0

proc autotoolsBuild*(installDir: string, url: string, tag: string): int =
  discard execProcess("./configure")
  if fileExists("CMakeLists.txt"):
    if findExe("cmake") == "":
      stdout.write "\n"
      echoPkgit()
      echo red & "[ERROR] " & colorReset & "Cmake isn't installed!"
      return 1
    createDir("build")
    setCurrentDir("build")
    discard execProcess("cmake ..")
  discard execProcess("make")
  return 0

proc cargoBuild*(installDir: string, url: string, tag: string): int =
  if findExe("cargo") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Cargo isn't installed!"
    return 1
  discard execProcess("cargo build --release")
  return 0

proc cmakeBuild*(installDir: string, url: string, tag: string): int =
  if findExe("cmake") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Cmake isn't installed!"
    return 1
  createDir("build")
  setCurrentDir("build")
  discard execProcess("cmake ..")
  discard execProcess("make")
  return 0

proc goBuild*(installDir: string, url: string, tag: string): int =
  if findExe("go") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Go isn't installed!"
    return 1
  discard execProcess("go env -w GOBIN=" & installDir)
  discard execProcess("go install " & url & "@" & tag)
  return 0

proc gradleBuild*(installDir: string, url: string, tag: string): int =
  if findExe("gradle") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Gradle isn't installed!"
    return 1
  discard execProcess("gradle build")
  return 0

proc makeBuild*(installDir: string, url: string, tag: string): int =
  if findExe("make") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Make isn't installed!"
    return 1
  elif fileExists("autogen.sh"):
    discard autogenBuild(installDir, url, tag)
  elif fileExists("configure.ac"):
    discard autotoolsBuild(installDir, url, tag)
  else:
    discard execProcess("make")
  return 0

proc mesonBuild*(installDir: string, url: string, tag: string): int =
  if findExe("meson") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Meson isn't installed!"
    quit(1)
    return 1
  discard execProcess("meson setup build")
  discard execProcess("meson compile -C build")
  return 0

proc ninjaBuild*(installDir: string, url: string, tag: string): int =
  if findExe("ninja") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Ninja isn't installed!"
    return 1
  discard execProcess("ninja")
  return 0

proc nixBuild*(installDir: string, url: string, tag: string): int =
  if findExe("nix") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Nix isn't installed!"
    return 1
  discard execProcess("nix run --experimental-features 'nix-command flakes'")
  discard execProcess("nix run git+" & url)
  return 0

proc nimBuild*(installDir: string, url: string, tag: string): int =
  if findExe("nimble") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Nimble isn't installed!"
    return 1
  discard execProcess("nimble build")
  return 0

proc pnpmBuild*(installDir: string, url: string, tag: string): int =
  if findExe("pnpm") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Pnpm isn't installed!"
    return 1
  discard execProcess("pnpm install")
  discard execProcess("pnpm run build")
  return 0

proc pythonBuild*(installDir: string, url: string, tag: string): int =
  if findExe("pipx") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Pipx isn't installed!"
    return 1
  let pyprojectToml = parseFile("pyproject.toml")
  let pypkg = pyprojectToml["project"]["name"].getStr()
  discard execProcess("export PIPX_BIN_DIR=" & installDir)
  discard execProcess("pipx install " & pypkg)
  return 0

proc zigBuild*(installDir: string, url: string, tag: string): int =
  if findExe("zig") == "":
    stdout.write "\n"
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Zig isn't installed!"
    return 1
  discard execProcess("zig build")
  return 0
