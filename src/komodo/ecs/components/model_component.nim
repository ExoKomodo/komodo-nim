import ../../lib/graphics/[
    color,
    model3d,
]

import ./component_macros

component ModelComponent:
  fields:
    color: Color
    model: Model3d

  create(
      modelPath: string,
      color: Color,
  ):
    result.model = newModel3d(modelPath)
    result.color = color

  init:
    discard

  destroy:
    self.model.destroy()

func `color=`*(self: ModelComponent; value: Color): auto = self.color = value
func color*(self: ModelComponent): auto = self.color

func model*(self: ModelComponent): auto = self.model
