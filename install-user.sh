nim c -d:release -o:pkgit src/pkgit.nim && ./pkgit a https://github.com/dacctal/pkgit.git
mv pkgit ~/.local/bin/pkgit
if [ ! -f "$HOME"/.config/pkgit ]; then
  mkdir -p "$HOME"/.config/pkgit
  echo """[general]
  user-level = true""" >> "$HOME"/.config/pkgit/config.toml
fi
