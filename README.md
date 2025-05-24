# NVIM configuration

## before start

for coverting to pdf use pandoc. `~/.pdf_style.css` makes formatting.

```bash
ls README.md | entr zsh -c "source ~/.zshrc && pandoc_pdf README.md README.pdf"
or
pandoc README.md -o README.pdf --pdf-engine=weasyprint --css=/home/mi/.pdf_style.css
```

## Introduction

Started from Kickstart.nvim configuration: <https://github.com/nvim-lua/kickstart.nvim>

Configuration is based on openSUSE, intention is to have fully functional IDE for
python, lua and cpp. There are also some plugins that make live less hard.
Plugin system is based on `lazy.nvim`.

config sit in ~/.config/nvim like this

```lint
<!-- markdownlint-disable -->
```

```text
    ├── init.lua
    ├── lua
    │   ├── lazy_plugs.lua              - load/install lazy.nvim and scan `plugin` folder
    │   ├── maps.lua                    - key mappings
    │   ├── plugins
    │   │   ├── autocompletion.lua
    │   │   ├── colorscheme.lua
    │   │   ├── formatting.lua
    │   │   ├── lsp.lua                 - including mason configuration
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

```lint
<!-- markdownlint-enable -->
```

## LSP *nvim-lspconfig*

Language Server Protocol, where all "inteligence tool" sit.

| language      |    server     | type chk. | linter        | debuger   |
|:--------------|:----------    |:----------|:--------------|--------   |
| **python**    |   pyright     | pyright   | pylint        | dap-python|
| **lua**       |   lua-ls      | lazydev   |               |           |
| **markdown**  |               |           | markdownlint  |           |
| **bash**      |               |           | ShellCheck    |           |
| **zsh**       |               |           | ShellCheck    |           |
| **css**       |   css-lsp     |           |               |           |
| **cpp**       |   clangd      |           | clangd        |           |

### helpers

- mason.nvim - install dependecies, like LSP servers and other tools.
Check with `:Mason`

### autocompletion

- blink.cmp

### linting `nvim-lint`

#### python

Add virtual env location (see: `update_python_path()` in lint.lua).
Executed as autocommand when starting linting.

### debuging

- nvim-dap

#### dap-python

Require `debugpy` available in venv and path to python (see linting/python).

Use `dap.ext.vscode` to read `launch.json`, by default in .vscode folder.
NVIM json parser is very strict, so probably you need to remove
commas at end of keys.

## addons plugin

here are plugins that give some nice usefull features and make nvim look even nicer

### telescope

### colorscheme
