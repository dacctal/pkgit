<div align="center">

  ![logo](./assets/logo.png)
  
*(package it!)*

</div>

## What is this?
pkgit is an unconventional package manager designed to compile & install packages directly from their git repository.

> ***[DISCLAIMER]***
>
> Due to the nature of pkgit, you are solely responsible for vetting the repos that you add to your system.
>
> Use at your own risk.

## Installation
### From Source
#### System-level
You can compile and install pkgit by running the install script:
```
git clone https://github.com/dacctal/pkgit
cd pkgit
./install-system.sh
```
This may ask you for your admin password in order to move the binary to `/usr/bin`

#### User-level
If you can't grant admin permissions, you can install pkgit at the user-level:
```
git clone https://github.com/dacctal/pkgit
cd pkgit
./install-user.sh
```

***Make sure the compile does not produce errors!***

### Nimble
You can also avoid cloning the repository entirely, and install directly; assuming you have the nimble package manager:
```
nimble install pkgit
```

When first running pkgit, it will ask you if you want to install packages at user-level. Answer according to the choice you made here.

## Post-install
Add pkgit to its own repo:
```
pkgit a https://github.com/dacctal/pkgit
```
***This allows pkgit to update itself, you'll want to do this!***

## Options

| subcommand        | long command              | description                       |
|-------------------|---------------------------|-----------------------------------|
| a [url.git]       | add [url, file]           | add a repo/repopkg                |
| i [pkgs]          | install [pkgs, urls]      | install a package/repo            |
| * -t:[tag]        | --tag:[tag]               | specify a tag                     |
| r [pkgs]          | remove [pkgs]             | removes an installed package      |
| * -r:[repo]       | --repo:[repo]             | remove a repo                     |
| f                 | files                     | list all files of a package       |
| s [pkgs]          | search [pkgs]             | search for packages               |
| l                 | list                      | list installed packages           |
| u                 | update                    | updates all installed packages    |

| flag              | long flag                 | description                       |
|-------------------|---------------------------|-----------------------------------|
| -h                | --help                    | display the help message          |
| -v                | --version                 | display version number            |

## Installing Packages
### Basic install
Assuming you have already added its respective repo, you can install a package by specifying its name:
```
pkgit install [pkgName]
```
Or you can use the short command:
```
pkgit i [pkgName]
```

If you want to specify a version other than the latest, you can use `--tag:` or `-t:`:
```
pkgit install [pkgName] --tag:[tag]
```

### Repo install
If you haven't added the package's repository yet, or you just want to be specific, you can install the package using its git URL:
```
pkgit install [url.git]
```

Installing specific versions works the same as with the package name:
```
pkgit install [url.git] --tag:[tag]
```

### List install
If you have multiple packages you want to install at once, you have a couple options.
1. The one-liner:
```
pkgit install [pkg1Name] [pkg2Name] --tag:[tag] [url1.git] [url2.git] --tag:[tag]
```
2. The package list:
    - Create a file with all the packages you want to install. The following is that file's syntax:
    ```
    [pkgName]
    [pkgName] [tagnumber]
    [url.git]
    [url.git] [tagnumber]
    ```
    - Run the install command with `--list:` or `-l:`:
    ```
    pkgit install --list:[filename]
    ```

## Removal
### Packages
Removing (uninstalling) a package is as simple as it seems:
```
pkgit remove [pkgName]
```
Or the short command:
```
pkgit r [pkgName]
```

### Repositories
Removing a repository is also relatively simple. Run the following command:
```
pkgit remove --repo:[pkgName]
```
It will then prompt you with every URL in your repo that matches this package's name. Select the index of the one you want to remove.

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
  nim c -d:release -o:pkgit src/pkgit.nim
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
`pkgit a [filename]`

You can also add repositories from a URL by running:
`pkgit a [URL]`
> [!NOTE]
> This only works if the URL leads to the RAW file.

From here, pkgit will add all the URLs into its own local repository in `/usr/pkgit/repos/repos`.

Because of this simplistic format, you can easily create and share repositories on your own, or using existing larger repos like the AUR and GURU repos.
