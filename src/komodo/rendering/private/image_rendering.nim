import options

import ../drawable
import ../resource_cache
import ../../color
import ../../math/[
  vector2,
  vector3,
]

from ../../private/raylib import nil


proc draw*(
  drawable: Drawable;
  cache: ResourceCache;
  root_position: Vector3 = Vector3();
) {.sideEffect.} =
  if drawable.kind == DrawableKind.image:
    let texture_opt = cache.load_texture(drawable)
    if texture_opt.is_some:
      let texture = raylib.Texture(texture_opt.unsafe_get())
      raylib.DrawTextureV(
        texture,
        Vector2(
          x: root_position.x,
          y: root_position.y,
        ),
        White,
      )

