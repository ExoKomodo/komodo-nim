import ./entity
import ./math/vector3
import ./logging
import ./rendering/drawable
import ./rendering/private/[
  image_rendering,
  resource_cache,
  shape_rendering,
  text_rendering,
]
import ./resource_config

import strformat

export drawable
export entity
export resource_cache
export resource_config


proc draw*(
  drawable: Drawable;
  cache: ResourceCache;
  config: ResourceConfig;
  root_position: Vector3 = Vector3();
) {.sideEffect.} =
  case drawable.kind:
    of DrawableKind.image:
      image_rendering.draw(
        drawable,
        cache,
        config,
        root_position=root_position,
      )
    of DrawableKind.text:
      text_rendering.draw(
        drawable,
        cache,
        config,
        root_position=root_position,
      )
    of DrawableKind.shape:
      shape_rendering.draw(
        drawable,
        config,
        root_position=root_position,
      )

proc draw*(
  entity: Entity;
  cache: ResourceCache;
  config: ResourceConfig;
) {.sideEffect.} =
  for drawable in entity.drawables:
    drawable.draw(
      cache,
      config,
      root_position=entity.position,
    )

