# gitstatus.yazi
gitstatus prompt plugin for Yazi,

Asynchronous task loading without blocking the rendering of other components

![image](https://github.com/DreamMaoMao/gitstatus.yazi/assets/30348075/7eeed54b-e7b0-4eb8-bf02-5e9de84d1a7b)


# Install 

### Linux

```bash
git clone https://github.com/DreamMaoMao/gitstatus.yazi.git ~/.config/yazi/plugins/gitstatus.yazi
```

### Windows

With `Powershell` :

```powershell
if (!(Test-Path $env:APPDATA\yazi\config\plugins\)) {mkdir $env:APPDATA\yazi\config\plugins\}
git clone https://github.com/DreamMaoMao/gitstatus.yazi.git $env:APPDATA\yazi\config\plugins\gitstatus.yazi
```
# Dependcy
- git

# Usage 

Add this to ~/.config/yazi/init.lua

```
require("gitstatus"):setup()
```
