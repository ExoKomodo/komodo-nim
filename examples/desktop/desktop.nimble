# Package

version       = "0.1.0"
author        = "James Orson"
description   = "Desktop example for Komodo"
license       = "MIT"
srcDir        = "src"
bin           = @["desktop"]
binDir        = "bin"


# Dependencies

requires "nim >= 1.4.2"
requires "komodo"

task buildDesktop, "Build Desktop example":
  exec "nimble --verbose --clibdir:../../libs/raylib/linux --clibdir:../../libs/raylib/window --gc:orc --threads:on --opt:speed -d:nimpretty -d:release build -Y"

task debugDesktop, "Debug Desktop example":
  exec "nimble --verbose --clibdir:../../libs/raylib/linux --clibdir:../../libs/raylib/window --gc:orc --threads:on -g --debugger:native -d:nimpretty build -Y"

task runDesktop, "Example":
  exec "nimble --verbose --clibdir:../../libs/raylib/linux --clibdir:../../libs/raylib/window --gc:orc --threads:on --opt:speed -d:nimpretty -d:release run -Y"
