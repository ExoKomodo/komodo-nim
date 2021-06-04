# Package

version       = "0.1.0"
author        = "James Orson"
description   = "Desktop example for Komodo"
license       = "MIT"
srcDir        = "src"
bin           = @["desktop"]
binDir        = "bin"
backend       = "c"


# Dependencies

requires "nim >= 1.4.2"
requires "komodo"

import strformat


const
  resource_dir = "resources"
  resource_output_dir = "bin/resources"
  resource_kinds = [
    "audio",
    "textures",
    "models",
  ]

proc cleanResources() =
  echo "Cleaning resource output directory..."
  
  exec fmt"rm -rf {resource_output_dir}"
  
  echo "Successfully cleaned resource output directory"

proc copyResources() =
  echo "Copying resource directories..."
  
  exec fmt"mkdir {resource_output_dir}"
  for kind in resource_kinds:
    echo fmt"Copying {kind} resources..."
    
    exec fmt"cp -r {resource_dir}/{kind} {resource_output_dir}/{kind}"
    
    echo fmt"Successfully copied {kind} resources"
  
  echo "Successfully copied resource directories"

task devBuild, "Build Desktop example":
  echo "Building desktop for quick development iteration"
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty build -Y"

task releaseBuild, "Build Desktop example with release optimizations":
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty -d:release build -Y"
  cleanResources()
  copyResources()

task dangerBuild, "Build Desktop example with danger optimizations":
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty -d:danger build -Y"
  cleanResources()
  copyResources()

task debug, "Debug Desktop example":
  exec "nimble --verbose --threads:on --gc:orc -g --debugger:native -d:nimpretty build -Y"
  cleanResources()
  copyResources()

task devRun, "Example":
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty run -Y"
  cleanResources()
  copyResources()

task releaseRun, "Run Desktop example with release optimizations":
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty -d:release run -Y"
  cleanResources()
  copyResources()

task dangerRun, "Run Desktop example with danger optimizations":
  exec "nimble --verbose --threads:on --gc:orc -d:nimpretty -d:danger run -Y"
  cleanResources()
  copyResources()

