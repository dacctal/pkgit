import os, osproc, parsetoml, tables
import help, pkgFromUrl, terminal, vars

proc autogenBuild*(installDir: string, url: string, tag: string): int =
  discard execProcess("./autogen.sh")
  discard execProcess("make")
  return 0

proc autotoolsBuild*(installDir: string, url: string, tag: string): int =
  discard execProcess("./configure")
  if fileExists("CMakeLists.txt"):
    if findExe("cmake") == "":
      eraseLine()
      echoPkgit()
      echo error & "Cmake isn't installed!"
      return 1
    createDir("build")
    setCurrentDir("build")
    discard execProcess("cmake ..")
  discard execProcess("make")
  return 0

proc cargoBuild*(installDir: string, url: string, tag: string): int =
  if findExe("cargo") == "":
    eraseLine()
    echoPkgit()
    echo error & "Cargo isn't installed!"
    return 1
  discard execProcess("cargo build --release")
  return 0

proc cmakeBuild*(installDir: string, url: string, tag: string): int =
  if findExe("cmake") == "":
    eraseLine()
    echoPkgit()
    echo error & "Cmake isn't installed!"
    return 1
  createDir("build")
  setCurrentDir("build")
  discard execProcess("cmake ..")
  discard execProcess("make")
  return 0

proc goBuild*(installDir: string, url: string, tag: string): int =
  if findExe("go") == "":
    eraseLine()
    echoPkgit()
    echo error & "Go isn't installed!"
    return 1
  discard execProcess("go env -w GOBIN=" & installDir)
  discard execProcess("go install " & url & "@" & tag)
  return 0

proc gradleBuild*(installDir: string, url: string, tag: string): int =
  if findExe("gradle") == "":
    eraseLine()
    echoPkgit()
    echo error & "Gradle isn't installed!"
    return 1
  discard execProcess("gradle build")
  return 0

proc makeBuild*(installDir: string, url: string, tag: string): int =
  if findExe("make") == "":
    eraseLine()
    echoPkgit()
    echo error & "Make isn't installed!"
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
    eraseLine()
    echoPkgit()
    echo error & "Meson isn't installed!"
    quit(1)
    return 1
  discard execProcess("meson setup build")
  discard execProcess("meson compile -C build")
  return 0

proc ninjaBuild*(installDir: string, url: string, tag: string): int =
  if findExe("ninja") == "":
    eraseLine()
    echoPkgit()
    echo error & "Ninja isn't installed!"
    return 1
  discard execProcess("ninja")
  return 0

proc nixBuild*(installDir: string, url: string, tag: string): int =
  if findExe("nix") == "":
    eraseLine()
    echoPkgit()
    echo error & "Nix isn't installed!"
    return 1
  discard execProcess("nix run --experimental-features 'nix-command flakes'")
  discard execProcess("nix run git+" & url)
  return 0

proc nimBuild*(installDir: string, url: string, tag: string): int =
  if findExe("nimble") == "":
    eraseLine()
    echoPkgit()
    echo error & "Nimble isn't installed!"
    return 1
  discard execProcess("nimble build")
  return 0

proc pnpmBuild*(installDir: string, url: string, tag: string): int =
  if findExe("pnpm") == "":
    eraseLine()
    echoPkgit()
    echo error & "Pnpm isn't installed!"
    return 1
  discard execProcess("pnpm install")
  discard execProcess("pnpm run build")
  return 0

proc pythonBuild*(installDir: string, url: string, tag: string): int =
  if findExe("pipx") == "":
    eraseLine()
    echoPkgit()
    echo error & "Pipx isn't installed!"
    return 1
  let pyprojectToml = parseFile("pyproject.toml")
  let pypkg = pyprojectToml["project"]["name"].getStr()
  discard execProcess("export PIPX_BIN_DIR=" & installDir)
  discard execProcess("pipx install " & pypkg)
  return 0

proc zigBuild*(installDir: string, url: string, tag: string): int =
  if findExe("zig") == "":
    eraseLine()
    echoPkgit()
    echo error & "Zig isn't installed!"
    return 1
  discard execProcess("zig build")
  return 0
