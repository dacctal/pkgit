nim c -d:release -o:pkgit src/pkgit.nim &&
  clear &&
  mv pkgit ~/.local/bin/pkgit
  if [ ! -f "$HOME"/.config/pkgit ]; then
    mkdir -p "$HOME"/.config/pkgit
  echo """[general]
user-level = true""" >> "$HOME"/.config/pkgit/config.toml
  fi
