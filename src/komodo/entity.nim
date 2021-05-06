import tables

import ./data_bag
import ./rendering/drawable
import ./utils/math/vector3


type
  Entity* = object
    data*: DataBag
    drawables*: seq[Drawable]
    position*: Vector3

func newEntity*(
  drawables: seq[Drawable];
  position: Vector3 = Vector3();
  data: DataBag;
): auto =
  Entity(
    data: data,
    drawables: drawables,
    position: position,
  )

