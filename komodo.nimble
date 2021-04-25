# Package

version       = "0.1.0"
author        = "ExoKomodo"
description   = "Port of Komodo game engine to Nim using raylib"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
binDir        = "bin"

# Dependencies

requires "nim >= 1.4.2"

task docKomodo, "Generate documentation":
  exec "nimble --verbose --threads:on doc --project --outdir:htmldocs --index:on ./src/komodo.nim --git.url:https://github.com/ExoKomodo/KomodoNim --git.commit:develop --git.devel:develop"

