# NVIM configuration

## Introduction

Started from Kickstart.nvim configuration: https://github.com/nvim-lua/kickstart.nvim

Configuration is based on openSUSE, intention is to have fully functional IDE for python, lua and cpp. There are also some plugins that make live less hard. Plugin system is based on `lazy.nvim`.

config sit in ~config/nvim like this

```
    ├── init.lua
    ├── lua
    │   ├── lazy_plugs.lua              - load/install lazy.nvim and scan `plugin` folder
    │   ├── maps.lua                    - key mappings
    │   ├── plugins
    │   │   ├── autocompletion.lua
    │   │   ├── colorscheme.lua
    │   │   ├── formatting.lua
    │   │   ├── lsp.lua
    │   │   ├── mini_nvim.lua
    │   │   ├── neo-tree.lua
    │   │   ├── startup.lua
    │   │   ├── telescope.lua
    │   │   ├── treesitter.lua
    │   │   └── which-key.lua
    │   ├── settings.lua                - nvim general settings
    │   └── startup                     - themes for `startup.nvim`
    │       └── themes
    │           └── my_dashboard.lua
```
## LSP


## python IDE

### autocompletion


## addons plugin

here are plugins that give some nice usefull features and make nvim look even nicer

### telescope


### colorscheme

