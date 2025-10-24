import strformat
import vars

proc echoPkgit*() =
  stdout.write boldYellow & "[" & boldMagenta & "pkgit" & boldYellow & "]\t" & colorReset

proc help*() =
  echo &"""
{boldMagenta}                                 ,          
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
{colorReset}  {green}ar{colorReset},   {yellow}add-repo {blue}[url.git]           {gray}# add a package to your repo
{colorReset}  {green}arp{colorReset},  {yellow}add-repo-pkg {blue}[url || file]   {gray}# add a list of repos
{colorReset}  {green}i{colorReset},    {yellow}install {blue}[pkgs]               {gray}# install a package
{colorReset}  {green}ir{colorReset},   {yellow}install-repo  {blue}[url.git]      {gray}# add and install a package
{colorReset}  {green}r{colorReset},    {yellow}remove {blue}[pkgs]                {gray}# remove an installed package
{colorReset}  {green}rr{colorReset},   {yellow}remove-repo {blue}[repos]          {gray}# remove a package repo
{colorReset}  {green}f{colorReset},    {yellow}files                        {gray}# list all files of a package
{colorReset}  {green}l{colorReset},    {yellow}list                         {gray}# list installed packages
{colorReset}  {green}s{colorReset},    {yellow}search {blue}[pkgs]                {gray}# search for packages
{colorReset}  {green}u{colorReset},    {yellow}update                       {gray}# update all installed packages

{red}flags{colorReset}:
{colorReset}  {green}-h{colorReset},   {yellow}--help                       {gray}# display this help message
{colorReset}  {green}-v{colorReset},   {yellow}--version                    {gray}# display version number
"""
