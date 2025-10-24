<div align="center">

  ![logo](./assets/logo.png)
  
*(package it!)*

</div>

## what is this?
pkgit is an unconventional package manager designed to create package repos purely from that package's git repo.

As it is, pkgit is capable of dependency management, but you will likely have to determine the dependency URLs for each package you install (`/etc/pkgit/deps/[pkg-name]`). There's not a universal way to check for dependencies without using an existing package manager (unless the repo you're installing has a deps.sh file).

## installation
### from source
you can compile and install pkgit by running the install script:
```
git clone https://github.com/dacctal/pkgit
cd pkgit
./install.sh
```
*[you can then remove the clone directory]*

### pkgit
you can install pkgit using pkgit:
```
pkgit ar https://github.com/dacctal/pkgit
pkgit i pkgit
```

## options

| subcommand        | long command              | description                       |
|-------------------|---------------------------|-----------------------------------|
| ar [url.git]      | add-repo [url.git]        | add a package to the local repo   |
| arp [url.git]     | add-repo-pkg [url.git]    | add a list of repos               |
| i [pkgs]          | install [pkgs]            | installs a package from the repo  |
| ir [url.git]      | install-repo [url.git]    | add and install a package         |
| r [pkgs]          | remove [pkgs]             | removes an installed package      |
| rr [pkgs]         | remove-repo [pkgs]        | removes a package repo            |
| l                 | list                      | list installed packages           |
| s [pkgs]          | search [pkgs]             | search for packages               |
| u                 | update                    | updates all installed packages    |

| flag              | long flag                 | description                       |
|-------------------|---------------------------|-----------------------------------|
| -h                | --help                    | display the help message          |
| -v                | --version                 | display version number            |
