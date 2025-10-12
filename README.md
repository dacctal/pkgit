<div align="center">

  ![logo](./assets/logo.png)
  
*(package it!)*

</div>

## what is this?
pkgit is an unconventional package manager designed to create package repos purely from that package's git repo.

As it is, pkgit is capable of dependency management, but you will likely have to determine the dependency URLs for each package you install (`/etc/pkgit/deps/[pkg-name]`). There's not a universal way to check for dependencies without using an existing package manager (unless the repo you're installing has a deps.sh file).

## installation
you can install pkgit by simply pasting the following command into your terminal:
```
curl https://raw.githubusercontent.com/dacctal/pkgit/refs/heads/main/bldit | bash
```

## options

| command           | long command              | description                       |
|-------------------|---------------------------|-----------------------------------|
| ar [url.git]      | add-repo [url.git]        | add a package to the local repo   |
| arp [url.git]     | add-repo-pkg [url.git]    | add a list of repos               |
| ir [url.git]      | install-repo [url.git]    | add and install a package         |
| i [pkgs]          | install [pkgs]            | installs a package from the repo  |
| r [pkgs]          | remove [pkgs]             | removes an installed package      |
| rr [pkgs]         | remove-repo [pkgs]        | removes a package repo            |
| lp                | list-pkgs                 | list installed packages           |
| lr                | list-repos                | list added repos                  |
| s [pkgs]          | search [pkgs]             | search for packages               |
| sy                | sync                      | updates the repo                  |
| up                | update                    | updates all installed packages    |
| ug                | upgrade                   | updates pkgit                     |
