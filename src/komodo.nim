from komodo/lib/color import nil
from komodo/lib/logging import nil
from komodo/lib/math import nil
from komodo/lib/window import nil

import komodo/rendering

import komodo/[
  entity,
  game_state,
]
export entity
export game_state

import strformat


proc draw(
  state: GameState;
  cache: ResourceCache;
) {.sideEffect.} =
  for entity in state.entities:
    rendering.draw(entity, cache)

proc run*(
  initial_state: GameState;
  pre_init: proc(state: GameState): GameState {.noSideEffect.};
  init: proc(state: GameState): GameState {.noSideEffect.};
  update: proc(state: GameState; delta: float): GameState {.noSideEffect.};
  exit: proc(state: GameState): GameState {.noSideEffect.};
): auto =
  logging.log_info("Initializing Komodo")
  var state = initial_state.pre_init()
  window.initialize(
    state.screen_size,
    state.title,
  )
  state = state.init()
  logging.log_info("Successfully initialized Komodo!")

  var cache = newResourceCache()
  while not window.is_closing():
    window.clear_screen(color.DarkGreen)

    state = state.update(window.get_delta())
    
    window.begin_draw()
    state.draw(cache)
    window.end_draw()
  
  logging.log_info("Exiting Komodo")
  result = state.exit()
  logging.log_info("Exited Komodo!")
