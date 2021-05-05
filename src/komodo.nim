from komodo/utils/color import nil
from komodo/utils/logging import nil
from komodo/utils/math import nil
from komodo/utils/window import nil

import komodo/rendering
import komodo/macro_helpers
import komodo/[
  entity,
  game_state,
  message,
]
export entity
export game_state
export math
export message

import strformat


proc draw(
  state: GameState;
  cache: ResourceCache;
) {.sideEffect.} =
  for entity in state.entities:
    rendering.draw(entity, cache)

proc handle_messages(
  initial_state: GameState;
  on_message: proc(state: GameState; message: Message): GameState {.noSideEffect.};
): GameState =
  result = initial_state
  for message in result.messages:
    result = result.on_message(message)
  result = result.messages <- @[]

proc run*(
  initial_state: GameState;
  pre_init: proc(state: GameState): GameState {.noSideEffect.};
  init: proc(state: GameState): GameState {.noSideEffect.};
  update: proc(state: GameState; delta: float): GameState {.noSideEffect.};
  on_message: proc(state: GameState; message: Message): GameState {.noSideEffect.};
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

    state = state.handle_messages(on_message)
    state = state.update(window.get_delta())
    
    window.begin_draw()
    state.draw(cache)
    window.end_draw()
  
  logging.log_info("Exiting Komodo")
  result = state.exit()
  logging.log_info("Exited Komodo!")
