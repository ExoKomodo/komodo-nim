import options
import strformat

import ../drawable
import ./resource_cache
import ../../math/[
  vector2,
  vector3,
]

from ../../private/raylib import nil


proc draw(
  font: raylib.Font;
  drawable: Drawable;
  root_position: Vector3 = Vector3();
) {.sideEffect.} =
  raylib.DrawTextEx(
    font, # TODO: Add font example with non-default
    drawable.text,
    Vector2(
      x: root_position.x,
      y: root_position.y,
    ),
    drawable.font_size,
    drawable.font_spacing,
    drawable.font_color,
  )

proc draw*(
  drawable: Drawable;
  cache: ResourceCache;
  root_position: Vector3 = Vector3();
) {.sideEffect.} =
  if drawable.kind == DrawableKind.text:
    let font_opt = cache.load_font(drawable)
    let font = if font_opt.is_some: raylib.Font(font_opt.unsafe_get()) else: raylib.GetFontDefault()
    font.draw(drawable, root_position)

