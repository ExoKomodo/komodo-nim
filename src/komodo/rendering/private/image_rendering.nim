import options
import strformat

import ../drawable
import ../resource_cache
import ../../game_state
import ../../color
import ../../logging
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
  case drawable.kind:
    of DrawableKind.image:
      let texture_opt = cache.load_texture(drawable)
      if texture_opt.is_none:
        return
      let texture = raylib.Texture(texture_opt.unsafe_get())
      raylib.DrawTextureV(
        texture,
        Vector2(
          x: root_position.x,
          y: root_position.y,
        ),
        White,
      )
    of DrawableKind.text:
      return
