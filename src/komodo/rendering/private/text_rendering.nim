import strformat

import ../drawable
import ../resource_cache
import ../../game_state
import ../../logging
import ../../math/vector3


proc draw*(
  drawable: Drawable;
  cache: ResourceCache;
  root_position: Vector3 = Vector3();
) {.sideEffect.} =
  log_debug(fmt"Text: '{drawable.text}' with {drawable.font_path}")
