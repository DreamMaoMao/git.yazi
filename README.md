# gitstatus.yazi
gitstatus prompt plugin for Yazi,

Asynchronous task loading without blocking the rendering of other components


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

# Usage 

Add this to ~/.config/yazi/init.lua

```
require("gitstatus"):setup()
```