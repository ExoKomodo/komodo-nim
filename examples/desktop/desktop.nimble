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
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty build -Y"

task releaseBuild, "Build Desktop example with release optimizations":
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty -d:release build -Y"

task dangerBuild, "Build Desktop example with danger optimizations":
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty -d:danger build -Y"

task debug, "Debug Desktop example":
  exec "nimble --verbose --threads:on --gc:orc -g --debugger:native -d:nimpretty build -Y"

task run, "Example":
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty run -Y"

task releaseRun, "Run Desktop example with release optimizations":
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty -d:release run -Y"

task dangerRun, "Run Desktop example with danger optimizations":
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty -d:danger run -Y"

