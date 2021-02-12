import options

import ./color
import ../math

from ../private/raylib import nil


type
  Model3d* = ref object of RootObj
    model: Option[raylib.Model]

proc unload(self: Model3d) =
  if self.model.isSome():
    raylib.UnloadModel(self.model.unsafeGet())
    self.model = none[raylib.Model]()

proc destroy*(self: Model3d) =
  self.unload()

proc newModel3d*(modelPath: string): Model3d =
  result = Model3d(
      model: some(raylib.LoadModel(modelPath))
  )

proc draw*(
    self: Model3d;
    position: Vector3;
    rotation: Vector3;
    scale: Vector3;
    color: Color = White;
    hasWireframe: bool = false;
    wireFrameColor: Color = Black;
) =
  if self.model.isNone():
    return
  let model = self.model.unsafeGet()
  raylib.DrawModelEx(
    model,
    position,
    rotation,
    0.0,
    scale,
    color,
  )
  if hasWireframe:
    raylib.DrawModelWiresEx(
      model,
      position,
      rotation,
      0.0,
      scale,
      wireframeColor,
    )
