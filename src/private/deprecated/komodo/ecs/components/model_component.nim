import ../../lib/graphics/[
    color,
    model3d,
]

import ./component_macros

component ModelComponent:
  fields:
    color: Color
    hasWireframe: bool
    model: Model3d
    wireframeColor: Color

  create(modelPath: string):
    result.model = newModel3d(modelPath)
    
    result.color = White
    result.hasWireframe = false
    result.wireframeColor = Black

  init:
    discard

  destroy:
    self.model.destroy()

func `color=`*(self: ModelComponent; value: Color) = self.color = value
func color*(self: ModelComponent): auto = self.color

func model*(self: ModelComponent): auto = self.model

func `hasWireframe=`*(
  self: ModelComponent;
  value: bool;
) = self.hasWireframe = value
func hasWireframe*(self: ModelComponent): bool = self.hasWireframe

func `wireframeColor=`*(self: ModelComponent; value: Color) = self.wireframeColor = value
func wireframeColor*(self: ModelComponent): auto = self.wireframeColor