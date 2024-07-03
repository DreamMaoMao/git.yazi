# message-custom.yazi
message prompt plugin for Yazi,

Asynchronous task loading without blocking the rendering of other components

![image](https://github.com/DreamMaoMao/message-custom.yazi/assets/30348075/7eeed54b-e7b0-4eb8-bf02-5e9de84d1a7b)



https://github.com/DreamMaoMao/message-custom.yazi/assets/30348075/44a7da1c-b135-472b-9c5b-d2f4f1fd48b6


# Install 

### Linux

```bash
git clone https://github.com/DreamMaoMao/message-custom.yazi.git ~/.config/yazi/plugins/message-custom.yazi
```

# Dependcy
- git

# Usage 

Add this to ~/.config/yazi/init.lua

```
require("message-custiom"):setup{
    folder_size_ignore = {"/home/wrq","/"},
    gitstatus_ignore = {"/home/wrq","/"},
    enable_folder_size = false
}
```
