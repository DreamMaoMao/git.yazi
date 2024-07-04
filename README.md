# git-status.yazi
git message prompt plugin for Yazi,

Asynchronous task loading without blocking the rendering of other components

![image](https://github.com/DreamMaoMao/git-status.yazi/assets/30348075/9dad8f43-caa2-46c1-bfc7-5bf90ba7a414)


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
