<div align="center">

  ![logo](./assets/logo.png)
  
*(package it!)*

</div>

## What is this?
pkgit is an unconventional package manager designed to compile & install packages directly from their git repository.

## Installation
### From Source
You can compile and install pkgit by running the install script:
```
git clone https://github.com/dacctal/pkgit
cd pkgit
./install-system.sh
```
This may ask you for your admin password in order to move the binary to `/usr/bin`

If you can't grant admin permissions, you can install pkgit at the user-level:
```
git clone https://github.com/dacctal/pkgit
cd pkgit
./install-user.sh
```

When first running pkgit, it will ask you if you want to install packages at user-level. Answer according to the choice you made here.

***Make sure this does not produce errors!***

*[You can then remove the clone directory]*

### pkgit
You can install pkgit using pkgit:
```
pkgit ar https://github.com/dacctal/pkgit
pkgit i pkgit
```

## Options

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

## Dependency Management
As it is, pkgit is capable of dependency management, but you will likely have to determine the dependency URLs for each package you install (`/etc/pkgit/deps/[pkg-name].pkgdeps`). There's not a universal way to check for dependencies without using an existing package manager (unless the repo you're installing has a pkgdeps file).

### [USER]: Creating a .pkgdeps file
Thankfully, this is a very simple process.

For each dependency, all you need to do in the .pkgdeps file is paste the dependency's remote git URL in its own line.

Here's an example for `/etc/pkgit/deps/mush.pkgdeps`:
```
https://github.com/mpv-player/mpv
https://github.com/yt-dlp/yt-dlp
https://github.com/FFmpeg/FFmpeg
https://github.com/curl/curl
https://github.com/quodlibet/mutagen
```

That's it! pkgit will read from this file and resolve these dependencies automatically.

### [DEVELOPER]: Pkgdeps in your package
If you want your own package's dependencies to be resolved in pkgit, you can create a `pkgdeps` file in the root directory of your project's git repo.

Do not name it anything other than `pkgdeps`, or pkgit will not find the file.

The syntax displayed above applies to this file.

> [!WARNING]
> Recursive dependency management does NOT work in pkgit, so you may want to list your dependencies accordingly.

## Custom Compile Instructions
### [USER]: Creating a bldit file
The bldit file is a very basic bash script, and is meant exclusively to COMPILE the program.

NOT to install the program.

Creating a custom bldit file is useful for those comfortable with going through compile steps manually.

The file is stored in `/etc/pkgit/bldit/` and is named after the package exactly (all lowercase).

It is also a very simple process to create a bldit file. A great example of a bldit file
is right here in the pkgit repository:
```
bldit() {
  nim c -d:release -o:pkgit src/main.nim
}
```
Basically, this defines a bash function called `bldit` that contains the steps to compile the program.

If you wanted to create your own custom bldit file for pkgit,
you would make a file: `/etc/pkgit/bldit/pkgit` and create your own bldit function in there.

### [DEVELOPER]: Bldit in your package
If your package doesn't build correctly using pkgit, you can create a `bldit` file in the root directory of your project's git repo.

Do not name it anything other than `bldit`, or pkgit will not find the file.

The syntax displayed above applies to this file.

## Custom Repositories
A custom repository is as simple to create as a `pkgdeps` file.

All you need is URLs separated by new lines. Each URL must correspond to a remote git repository of a package.

The file name doesn't matter in this case, because you will add this repository by running:
`pkgit arp [filename]`

You can also add repositories from a URL by running:
`pkgit arp [URL]`
> [!NOTE]
> This only works if the URL leads to the RAW file.

From here, pkgit will add all the URLs into its own local repository in `/usr/pkgit/repos/repos`.

Because of this simplistic format, you can easily create and share repositories on your own, or using existing larger repos like the AUR and GURU repos.
