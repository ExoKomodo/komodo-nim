# Komodo Editor
[Documentation](https://exokomodo.github.io/KomodoNim/komodo.html)

## Setup

### Windows

#### Install Scoop
Follow the instructions found on [Scoop's website](https://scoop.sh), or run the following commmands:
```PowerShell
iwr -useb get.scoop.sh | iex
```

#### Install Nim
Install nim with
```PowerShell
scoop install nim
```

#### IUP Setup
Copy the `*.dll` and `*.lib` files from `libs/iup/windows` into `C:\Windows\System32`

### Linux

#### Install choosenim
Follow the install instructions found on [choosenim's repo](https://github.com/dom96/choosenim), or run the following commands:
```bash
curl https://nim-lang.org/choosenim/init.sh -sSf | sh
```
You will need to update your path in your `.bashrc`:
```bash
export PATH=~/.nimble/bin:$PATH
```

#### Install Nim
Install nim with
```bash
choosenim stable
```

#### IUP Setup
Copy the `*.so` and `*.a` files from `libs/iup/linux` into `/usr/local/lib`

## Important Links
* [IUP Documentation](http://webserver2.tecgraf.puc-rio.br/iup)
* [IUP Windows download](https://sourceforge.net/projects/iup/files/3.30/Windows%20Libraries/Dynamic/iup-3.30_Win64_dll16_lib.zip/download)
* [IUP Linux download](https://sourceforge.net/projects/iup/files/3.30/Linux%20Libraries/iup-3.30_Linux54_64_lib.tar.gz/download)
