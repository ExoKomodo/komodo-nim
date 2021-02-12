# Package

version       = "0.1.0"
author        = "James Orson"
description   = "GUI editor for the Komodo game engine"
license       = "MIT"
srcDir        = "src"
bin           = @["komodoeditor"]
binDir        = "bin"


# Dependencies

requires "nim >= 1.4.2"
requires "komodo"
requires "iup"

task buildEditor, "Build Komodo Editor":
  exec "nimble --gc:orc --threads:on -d:nimpretty build -Y"

task debugEditor, "Debug Komodo Editor":
  exec "nimble --gc:orc --threads:on -g --debugger:native -d:nimpretty build -Y"

task runEditor, "Run":
  exec "nimble --gc:orc --threads:on -d:nimpretty run -Y"
