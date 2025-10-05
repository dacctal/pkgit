# pkgit
package it!

## what is this?
pkgit is an unconventional package manager designed to create package repos purely from that package's git repo.

As it is, pkgit is not capable of dependency management, so you will have to manage your own dependencies for each package you install. There's not a universal way to check for dependencies without using an existing package manager.

## installation
you can install pkgit by simply pasting the following command into your terminal:
```curl https://raw.githubusercontent.com/dacctal/pkgit/refs/heads/main/bldit | bash```

## options

| command         | long command            | description                       |
|-----------------|-------------------------|-----------------------------------|
| ar [url.git]    | add-repo [url.git]      | add a package to the local repo   |
| i [pkgs]        | install [pkgs]          | installs a package from the repo  |
| r [pkgs]        | remove [pkgs]           | removes an installed package      |
| ls              | list                    | list installed packages           |
| s [pkgs]        | search [pkgs]           | search for packages               |
| sy              | sync                    | updates the repo                  |
| up              | update-packages         | updates all installed packages    |
