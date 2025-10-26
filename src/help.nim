import strformat
import vars

proc echoPkgit*() =
  stdout.write boldYellow & "[" & boldMagenta & "pkgit" & boldYellow & "]\t" & colorReset

proc help*() =
  echo &"""
{boldMagenta}                              ,          
                             {boldMagenta}/ \         
                            {boldMagenta}/   \        
                        {boldMagenta}__-'     '-__    
                      {boldMagenta}''--__     __--''  {boldYellow}
                         {boldYellow}_--{boldMagenta}\   /{boldYellow}--_     
                     {boldYellow}_--'    {boldMagenta}\ /{boldYellow}    '--_ 
                    {boldYellow}'-__      {boldMagenta}'{boldYellow}      __-'
                        {boldYellow}'-__     __-'    
                            {boldYellow}'-_-'        {colorReset}

                            pkgit
                       {italic}{gray}- package it! -{colorReset}
                       {magenta}v{version}{colorReset}

{red}subcommands{colorReset}:
{colorReset}├─ {green}a{colorReset},   {yellow}add {blue}[url, file]        {gray}# add a repo/repopkg
{colorReset}├┬ {green}i{colorReset},   {yellow}install {blue}[pkgs, urls]   {gray}# install a package/repo
{colorReset}│├── {green}-t:{colorReset}, {yellow}--tag:{blue}[tag]          {gray}# specify a version
{colorReset}│└── {green}-l:{colorReset}, {yellow}--list:{blue}[filename]    {gray}# install from a package list
{colorReset}├┬ {green}r{colorReset},   {yellow}remove {blue}[pkgs]          {gray}# remove an installed package
{colorReset}│└── {green}-r:{colorReset}, {yellow}--repo:{blue}[repo]        {gray}# remove a repo
{colorReset}├─ {green}f{colorReset},   {yellow}files {blue}[pkgs]           {gray}# list all files of a package
{colorReset}├─ {green}s{colorReset},   {yellow}search {blue}[pkgs]          {gray}# search for packages
{colorReset}├─ {green}l{colorReset},   {yellow}list                   {gray}# list installed packages
{colorReset}└─ {green}u{colorReset},   {yellow}update                 {gray}# update all installed packages

{red}flags{colorReset}:
{colorReset}├─ {green}-h{colorReset},  {yellow}--help                 {gray}# display this help message
{colorReset}└─ {green}-v{colorReset},  {yellow}--version              {gray}# display version number
"""
