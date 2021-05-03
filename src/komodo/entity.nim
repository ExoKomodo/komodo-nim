import ./utils/math/vector3
import ./rendering/drawable


type
  Entity* = object
    drawables*: seq[Drawable]
    position*: Vector3

func newEntity*(
  drawables: seq[Drawable];
  position: Vector3 = Vector3();
): auto =
  Entity(
    drawables: drawables,
    position: position,
  )
