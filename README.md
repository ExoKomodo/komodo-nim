# Komodo
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

#### Raylib Setup
Copy the libraries found in the project's `libs/raylib/windows` directory to `C:\Windows\System32`.

### Mac OS

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

#### Raylib Setup
Install raylib with 
```bash
brew install raylib
```

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

#### Raylib Setup
Either copy the `libraylib.so` file from `libs/raylib/linux` into `/usr/local/lib`, or follow the install instructions found on [raylib's repo wiki](https://github.com/raysan5/raylib/wiki/Working-on-GNU-Linux) to build from source and install like so:
```bash
cd /tmp
git clone https://github.com/raysan5/raylib.git raylib
cd raylib/src/
make PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=SHARED
sudo make install RAYLIB_LIBTYPE=SHARED
```

## Important Links
* [raylib bindings](https://github.com/Guevara-chan/Raylib-Forever)
* [raylib cheatsheet](https://www.raylib.com/cheatsheet/cheatsheet.html)
* [raylib releases](https://github.com/raysan5/raylib/releases)
* [IUP documentation](http://webserver2.tecgraf.puc-rio.br/iup)