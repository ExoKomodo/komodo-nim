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

task build, "Build Desktop example":
  exec "nimble --gc:orc -d:nimpretty build"

task debug, "Debug Desktop example":
  exec "nimble --gc:orc -g --debugger:native -d:nimpretty build"

task example, "Example":
  exec "nimble --gc:orc -d:nimpretty run"
