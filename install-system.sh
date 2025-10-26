nim c -d:release -o:pkgit src/pkgit.nim && sudo mv pkgit /usr/bin/pkgit
if [ -f "$HOME"/.config/pkgit/config.toml ]; then
  rm "$HOME"/.config/pkgit/config.toml
fi
if [ ! -f /etc/pkgit/config.toml ]; then
  sudo mkdir -p /etc/pkgit
  echo """[general]
  user-level = false""" | sudo tee -a /etc/pkgit/config.toml
fi
