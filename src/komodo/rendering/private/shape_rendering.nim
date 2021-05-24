import options

import ../drawable
import ../../color
import ../../math/[
  vector2,
  vector3,
]

from ../../private/raylib import nil


proc draw*(
  shape: Shape,
  root_position: Vector3 = Vector3();
) {.sideEffect.} =
  let position = Vector2(
    x: root_position.x,
    y: root_position.y,
  )
  case shape.kind:
  of ShapeKind.line:
    raylib.DrawLineEx(
      position + shape.start_point,
      position + shape.end_point,
      shape.thickness,
      shape.color,
    )
  of ShapeKind.circle:
    raylib.DrawCircleV(
      position + shape.center,
      shape.radius,
      shape.color,
    )
  of ShapeKind.rectangle:
    raylib.DrawRectanglePro(
      shape.rect,
      position,
      shape.rotation,
      shape.color,
    )

proc draw*(
  drawable: Drawable;
  root_position: Vector3 = Vector3();
) {.sideEffect.} =
  if drawable.kind == DrawableKind.shape:
    drawable.shape.draw(root_position)

