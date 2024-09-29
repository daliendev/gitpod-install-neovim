# Installing Neovim in Gitpod     

### Goal:   
Use [Neovim](https://github.com/neovim/neovim) as primary IDE inside [Gitpod](https://www.gitpod.io/) workspaces.    
Just by connecting to the workspace from a terminal.    

### How:    
 
By setting `https://github.com/daliendev/gitpod-install-neovim` as Gitpod Dotfiles repository in [gitpod.io/preferences](https://gitpod.io/preferences),     
Neovim will be installed with the appropriate [configuration](https://github.com/daliendev/astro-nvim) in every Gitpod workspace.      

#### (Optional) Get a Nerd Font      
*(install it on the system, e.g. on Windows for WSL2)*     

If you haven't installed it yet, you might need a Nerd Font on the terminal you'll use to connect to the Gitpod Workspace via SSH.     
https://www.nerdfonts.com/font-downloads    

#### (Optional) Share a port   

As you work on creating something new, you might want to view your changes in a web browser. To do this, you'll need to run the following command on your local machine:     
```bash
ssh -L $PORT$:localhost:$PORT$ username@remote-server
```

#### (Optional) Mount the workspace directory

You also may need to upload some file to the workspace from your local machine (e.g. your homepage banner).   
For one unique file you may just use `scp`, but you also can mount the whole workspace with `sshfs`:    
```bash
sudo apt install sshfs
mkdir ~/folder-to-mount
sshfs -o default_permissions username@remote-server:/workspace/repository-name ~/folder-to-mount
```
