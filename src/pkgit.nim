import os, osproc, posix, strutils
import addRepo, addRepoPkg, ensureSu, filesPkg, help, installList, installPkg, installRepo, listPkgs, pkgFromUrl, removeRepo, removePkg, searchPkgs, setup, updatePkgs, vars

proc main() =
  setup()
  
  setCurrentDir(getCurrentDir())

  let args = commandLineParams()
  if args.len > 0:
    case args[0]:
      of "a", "add":
        if args.len > 1:
          for i in 1 ..< args.len:
            let gitAttempt = execProcess("git ls-remote " & args[i])
            if fileExists(args[i]) or gitAttempt.contains("fatal"):
              if not userLevelMode:
                ensureSu()
                addRepoPkg(args[i])
              else:
                addRepoPkg(args[i])
            else:
              if not gitAttempt.contains("fatal"):
                if not userLevelMode:
                  ensureSu()
                  discard addRepo(args[i])
                else:
                  discard addRepo(args[i])
              else: 
                echoPkgit()
                echo red & "[ERROR] " & colorReset & "repo/repopkg does not exist!"

      of "i", "install":
        if args.len > 1:
          for i in 1 ..< args.len:
            var tag: string
            if args.len > 2:
              if args[i].contains("-t:") or args[i].contains("--tag:"):
                continue
              if args[i+1].contains("-t:"):
                tag = args[i+1].replace("-t:", "")
                if args[i].startsWith("http") or args[i].startsWith("file:///"):
                  if not userLevelMode:
                    ensureSu()
                    installRepo(args[i], tag)
                  else:
                    installRepo(args[i], tag)
                else:
                  if not userLevelMode:
                    ensureSu()
                    installPkg(args[i], tag)
                  else:
                    installPkg(args[i], tag)
              elif args[i+1].contains("--tag:"):
                tag = args[i+1].replace("--tag:", "")
                if args[i].startsWith("http"):
                  if not userLevelMode:
                    ensureSu()
                    installRepo(args[i], tag)
                  else:
                    installRepo(args[i], tag)
                else:
                  if not userLevelMode:
                    ensureSu()
                    installPkg(args[i], tag)
                  else:
                    installPkg(args[i], tag)
            elif args[i].contains("-l:"):
              let pkg = args[i].replace("-l:", "")
              if not userLevelMode:
                ensureSu()
                installList(pkg)
              else:
                installList(pkg)
            elif args[i].contains("--list:"):
              let pkg = args[i].replace("--list:", "")
              if not userLevelMode:
                ensureSu()
                installList(pkg)
              else:
                installList(pkg)
            elif args[i].startsWith("http"):
              if not userLevelMode:
                ensureSu()
                installRepo(args[i])
              else:
                installRepo(args[i])
            else:
              if not userLevelMode:
                ensureSu()
                installPkg(args[i])
              else:
                installPkg(args[i])
        else:
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Needs a parameter!"

      of "l", "list":
        listPkgs()

      of "r", "remove":
        if args.len > 1:
          for i in 1 ..< args.len:
            if args[i].contains("-r:"):
              echoPkgit()
              echo "Repo queued for removal: " & args[i].replace("-r:", "")
              if not userLevelMode:
                ensureSu()
                removeRepo(args[i].replace("-r:", ""))
              else:
                removeRepo(args[i].replace("-r:", ""))
            elif args[i].contains("--repo:"):
              if not userLevelMode:
                ensureSu()
                removeRepo(args[i].replace("--repo:", ""))
              else:
                removeRepo(args[i].replace("--repo:", ""))
            else:
              if not userLevelMode:
                ensureSu()
                removePkg(args[i])
              else:
                removePkg(args[i])
        else:
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Needs a parameter!"

      of "s", "search":
        if args.len > 1:
          for i in 1 ..< args.len:
            for result in searchPkgs(args[i]):
              let url = result.replace("@[\"", "").replace("\"]", "")
              let pkg = pkgFromUrl(result)
              if pkg.len < 8:
                echo green & pkg & ":\t\t" & blue & url & colorReset
              else:
                echo green & pkg & ":\t" & blue & url & colorReset
        else:
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Needs a parameter!"

      of "f", "files":
        if args.len > 1:
          for i in 1 ..< args.len:
            for result in searchPkgs(args[i]):
              filesPkg(args[i])
        else:
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Needs a parameter!"

      of "u", "update":
        if not userLevelMode:
          ensureSu()
          updatePkgs()
        else:
          updatePkgs()

      of "-h", "--help":
        help()

      of "-v", "--version":
        echo "pkgit " & version

      else:
        echo ""
        echoPkgit()
        echo args[0] & ": invalid option"
        echo ""
        help()
  else:
    help()

when isMainModule:
  main()
