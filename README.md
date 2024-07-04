# git-status.yazi
git message prompt plugin for Yazi,

Asynchronous task loading without blocking the rendering of other components

![image](https://github.com/DreamMaoMao/git-status.yazi/assets/30348075/3a95e25a-cf0e-4f03-8d92-e7c9cc0767bb)


# Install 

### Linux

```bash
git clone https://github.com/DreamMaoMao/git-status.yazi.git ~/.config/yazi/plugins/git-status.yazi
```

# Dependcy
- git

# Usage 

Add this to ~/.config/yazi/init.lua

```
require("git-status"):setup{
    style = "beside" -- beside or linemode
}
```
