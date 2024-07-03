# git-status.yazi
git message prompt plugin for Yazi,

Asynchronous task loading without blocking the rendering of other components

![image](https://github.com/DreamMaoMao/git-status.yazi/assets/30348075/8f3c2bdd-355a-405f-8a20-b390849c5882)


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
    folder_size_ignore = {"/home/user","/"},
    gitstatus_ignore = {"/home/user","/"},
    enable_folder_size = false
}
```
