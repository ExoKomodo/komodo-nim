import options

import ./color
import ../math

from ../private/raylib import nil


type
  Texture2d* = ref object of RootObj
    texture: Option[raylib.Texture2D]

func unload(self: Texture2d) =
  if self.texture.isSome:
    raylib.UnloadTexture(self.texture.unsafeGet())
    self.texture = none[raylib.Texture2D]()

func destroy*(self: Texture2d) =
  self.unload()

func newTexture2d*(texturePath: string): Texture2d =
  let image = raylib.LoadImage(texturePath)
  result = Texture2d(
      texture: some(raylib.LoadTextureFromImage(image))
  )
  raylib.UnloadImage(image)

func draw*(
    self: Texture2d;
    position: Vector3;
    rotation: Vector3;
    scale: Vector3;
    color: Color;
) =
  if self.texture.isNone:
    return
  let texture = self.texture.unsafeGet()
  raylib.DrawTextureEx(
      texture,
      Vector2(
          x: position.x,
          y: position.y,
    ),
    rotation.z,
    scale.x,
    color,
  )
