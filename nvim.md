## neovim setup

Install [neovim](https://github.com/neovim/neovim) and nodejs.
Arch:
```
pacman -S neovim python-pynvim nodejs npm
```

Link configs:
```
mkdir -p $HOME/.config/nvim
ln -sfv $HOME/conf/nvim/advanced.vim $HOME/.config/nvim/init.vim
ln -sfv $HOME/conf/nvim/coc-settings.json $HOME/.config/nvim/coc-settings.json
```

Install [vim-plug](https://github.com/junegunn/vim-plug)
```
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim -c 'PlugInstall'
nvim -c "CocInstall coc-json"
```

## language specific setups
