import ../../lib/graphics/[
    color,
    texture2d,
]

import ./component_macros

component SpriteComponent:
  fields:
    color: Color
    texture: Texture2d

  create(
      texturePath: string,
      color: Color,
  ):
    result.texture = newTexture2d(texturePath)
    result.color = color

  init:
    discard

  destroy:
    self.texture.destroy()

func `color=`*(self: SpriteComponent; value: Color): auto = self.color = value
func color*(self: SpriteComponent): auto = self.color

func texture*(self: SpriteComponent): auto = self.texture
