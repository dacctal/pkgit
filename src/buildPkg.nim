import std/[dirs, symlinks], os, osproc, strformat, strutils, tables, terminal
import buildSys, help, pkgFromUrl, runLoading, vars

proc isExecutable(path: string): bool =
  if not fileExists(path):
    return false
  let perms = getFilePermissions(path)
  return fpUserExec in perms or fpGroupExec in perms or fpOthersExec in perms

proc buildPkg*(url: string, tagNum: string = "HEAD") =
  let pkg = pkgFromUrl(url)
  var tag: string
  tag = tagNum
  let srcDir = buildDir & "/" & pkg & "/" & tag
  let installDir = pkgsDir & "/" & pkg & "/" & tag
  removeDir(srcDir)

  if tag == "HEAD":
    var cloneMsg = execProcess("git -c advice.detachedHead=false clone --depth 1 " & url & " " & srcDir)
    echo cloneMsg
    if cloneMsg.contains("fatal"):
      echoPkgit()
      echo red & "[ERROR] " & colorReset & "Could not clone repository: " & url
      quit(1)
  else:
    var cloneMsg = execProcess("git -c advice.detachedHead=false clone --branch " & tag & " --depth 1 " & url & " " & srcDir)
    if cloneMsg.contains("fatal"):
      echoPkgit()
      echo red & "[ERROR] " & colorReset & "Could not clone repository: " & url
      quit(1)

  try:
    setCurrentDir(srcDir)
  except:
    echoPkgit()
    echo red & "[ERROR] " & colorReset & "Failed to change directory to " & srcDir
    quit(1)

  var funcMap = initTable[string, proc(a: string, b: string, c: string): int]()
  funcMap["autogen.sh"] = autogenBuild
  funcMap["configure"] = autotoolsBuild
  funcMap["configure.ac"] = autotoolsBuild
  funcMap["Cargo.toml"] = cargoBuild
  funcMap["CMakeLists.txt"] = cmakeBuild
  funcMap["go.mod"] = goBuild
  funcMap["gradle.build"] = gradleBuild
  funcMap["Makefile"] = makeBuild
  funcMap["Makefile.am"] = makeBuild
  funcMap["meson.build"] = mesonBuild
  funcMap["build.ninja"] = ninjaBuild
  funcMap["flake.nix"] = nixBuild
  funcMap["pnpm-lock.yaml"] = pnpmBuild
  funcMap["pyproject.toml"] = pythonBuild
  funcMap["build.zig"] = zigBuild

  var buildSysExists: bool
  if fileExists(blditDir & "/" & pkg):
    echoPkgit()
    echo green & "[DETECTED] " & colorReset & "Build system:\t" & blue & "Custom bldit"
    echoPkgit()
    stdout.write blue & "Building "
    try:
      runLoading(proc() = discard execProcess("source " & blditDir / pkg & " && bldit"))
      stdout.write colorReset
      eraseLine()
      echoPkgit()
      echo green & "[SUCCESS] " & colorReset & "Package built:\t" & green & pkg & colorReset
      buildSysExists = true
    except:
      stdout.write "\n"
      echoPkgit()
      echo red & "[ERROR] " & colorReset & "Build Failed!"
  elif fileExists("bldit"):
    echoPkgit()
    echo green & "[DETECTED] " & colorReset & "Build system:\t" & blue & "bldit"
    echoPkgit()
    stdout.write blue & "Building "
    try:
      runLoading(proc() = discard execProcess("source bldit && bldit"))
      stdout.write colorReset
      eraseLine()
      echoPkgit()
      echo green & "[SUCCESS] " & colorReset & "Package built:\t" & green & pkg & colorReset
      buildSysExists = true
    except:
      stdout.write "\n"
      echoPkgit()
      echo red & "[ERROR] " & colorReset & "Build Failed!"
  else:
    for key, function in funcMap.pairs:
      if fileExists(key):
        echoPkgit()
        echo green & "[DETECTED] " & colorReset & "Build system:\t" & blue & key
        echoPkgit()
        stdout.write blue & "Building "
        try:
          var failed: bool
          runLoading(proc() =
            if function(installDir, url, tag) == 1:
              failed = true
          )
          stdout.write colorReset
          if failed:
            echo ""
            continue
          eraseLine()
          echoPkgit()
          echo green & "[SUCCESS] " & colorReset & "Package built:\t" & green & pkg & colorReset
          buildSysExists = true
          break
        except:
          eraseLine()
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Build Failed!"
          continue
      else:
        buildSysExists = false

  if not buildSysExists:
    for kind, path in walkDir("."):
      if path.endsWith(".nimble"):
        echoPkgit()
        echo green & "[DETECTED] " & colorReset & "Build system:\t" & blue & path
        echoPkgit()
        stdout.write blue & "Building "
        try:
          var failed: bool
          runLoading(proc() =
            if nimBuild(installDir, url, tag) == 1:
              failed = true
          )
          stdout.write colorReset
          if failed:
            echo ""
            continue
          eraseLine()
          echoPkgit()
          echo green & "[SUCCESS] " & colorReset & "Package built:\t" & green & pkg & colorReset
          buildSysExists = true
          break
        except:
          eraseLine()
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Build Failed!"
          continue
      else:
        echoPkgit()
        echo red & "[ERROR] " & colorReset & "No build system found."
        quit(1)


  echoPkgit()
  stdout.write blue & "Installing "
  runLoading(proc() =
    for item in walkDirRec(srcDir):
      if dirExists(item):
        if item.splitPath().tail == "include":
          copyDir(item, includeDir / pkg)
        elif item.splitPath().tail == "bin":
          copyDir(item, binDir / pkg)
        elif item.splitPath(
          ).tail == "lib" or item.splitPath(
            ).tail == "libs" or item.splitPath(
              ).tail == "lib32" or item.splitPath(
                ).tail == "lib64":
          copyDir(item, libDir / pkg)
        else:
          continue

      let fileName = item.splitPath().tail
      if isExecutable(item):
        if fileName != "bldit":
          let installPath = installDir / fileName
          createDir(installDir)

          if not fileExists(installPath):
            copyFileWithPermissions(item, installPath)
      elif fileName.endsWith(".h"):
        let installPath = includeDir / fileName
        createDir(includeDir)

        if not fileExists(installPath):
          copyFileWithPermissions(item, installPath)
      elif fileName.endsWith(
      ".so"
      ) or fileName.contains(
      ".so."
      ) or fileName.endsWith(
      ".o"
      ) or fileName.contains(
      ".o."
      ) or fileName.endsWith(
      ".a"
      ) or fileName.contains(
      ".a."
      ) or fileName.endsWith(
      ".prl"
      ) or fileName.endsWith(
      ".spec"
      ):
        let installPath = libDir / fileName
        createDir(libDir)

        if not fileExists(installPath):
          copyFileWithPermissions(item, installPath)
  )
  stdout.write colorReset
  eraseLine()
  echoPkgit()
  echo green & "[SUCCESS] " & colorReset & "Installed binaries"

  echoPkgit()
  echo "Do you want to create a desktop file for " & pkg & "?"
  stdout.write "[y/N]: "
  var createApp = readLine(stdin)
  stdout.write "\n"
  if createApp.toLower == "y":
    var execProg: string
    for item in walkDirRec(srcDir):
      if item.extractFileName.toLower == pkg:
        execProg = item
      else:
        continue
    let application = fmt"""[Desktop Entry]
Name={pkg}
Exec={execProg}
Type=Application
Terminal=false"""
    let file = appDir / pkg & ".desktop"
    writeFile(file, application)
    echoPkgit()
    echo green & "[SUCCESS] " & colorReset & file & " created"

  echoPkgit()
  stdout.write blue & "Linking "
  runLoading(proc() =
    for item in walkDirRec(installDir):
      if dirExists(item):
        continue

      let fileName = item.splitPath().tail
      if isExecutable(item):
        let symlinkPath = binDir / fileName

        if not fileExists(symlinkPath):
          createSymlink(item, symlinkPath)
        else:
          continue
  )
  stdout.write colorReset
  eraseLine()
  echoPkgit()
  echo green & "[SUCCESS] " & colorReset & "Created symlinks"
