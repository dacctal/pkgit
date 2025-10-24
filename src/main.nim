import os, posix, strutils
import addRepo, addRepoPkg, ensureSu, filesPkg, help, installPkg, installRepo, listPkgs, pkgFromUrl, removeRepo, removePkg, searchPkgs, setup, updatePkgs, vars

proc main() =
  setup()
  
  let args = commandLineParams()
  if args.len > 0:
    case args[0]:
      of "ar", "add-repo":
        if args.len > 1:
          ensureSu()
          discard addRepo(args[1])
        else:
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Needs a parameter!"
      of "arp", "add-repo-pkg":
        if args.len > 1:
          ensureSu()
          addRepoPkg(args[1])
        else:
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Needs a parameter!"
      of "i", "install":
        if args.len > 1:
          for i in 1 ..< args.len:
            ensureSu()
            installPkg(args[i])
        else:
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Needs a parameter!"
      of "ir", "install-repo":
        if args.len > 1:
          var tag: string
          if args.len > 2:
            tag = args[2]
          else:
            tag = "HEAD"
          installRepo(args[1], tag)
        else:
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Needs a parameter!"
      of "l", "list":
        listPkgs()
      of "r", "remove":
        if args.len > 1:
          for i in 1 ..< args.len:
            ensureSu()
            removePkg(args[i])
        else:
          echoPkgit()
          echo red & "[ERROR] " & colorReset & "Needs a parameter!"
      of "rr", "remove-repo":
        if args.len > 1:
          for i in 1 ..< args.len:
            ensureSu()
            removeRepo(args[i])
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
        ensureSu()
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
