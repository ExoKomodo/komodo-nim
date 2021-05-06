from komodo/utils/color import nil
from komodo/utils/logging import nil
from komodo/utils/math import nil
from komodo/utils/window import nil

import komodo/rendering
import komodo/macro_helpers
import komodo/[
  data_bag,
  entity,
  game_state,
  message,
]
export entity
export game_state
export math
export message

import std/exitprocs
import strformat

from sugar import `=>`


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

proc cleanup(state: ref GameState; exit: proc(state: GameState); cache: ResourceCache) {.noconv.} =
  cache.unload()
  logging.log_info("Exiting Komodo...")
  state[].exit()
  logging.log_info("Exited Komodo!")

proc box[T](x: T): ref T =
  new(result); result[] = x

proc run*(
  initial_state: GameState;
  pre_init: proc(state: GameState): GameState {.noSideEffect.};
  init: proc(state: GameState): GameState {.noSideEffect.};
  update: proc(state: GameState; delta: float): GameState {.noSideEffect.};
  on_message: proc(state: GameState; message: Message): GameState {.noSideEffect.};
  exit: proc(state: GameState);
): GameState =
  logging.log_info("Initializing Komodo...")
  result = initial_state.pre_init()
  var state_ref = box[GameState](result)
  window.initialize(
    result.screen_size,
    result.title,
  )
  result = result.init()
  logging.log_info("Initialized Komodo!")

  var cache = newResourceCache()
  let exit_proc = () => cleanup(state_ref, exit, cache)
  addExitProc(exit_proc)
  setControlCHook(() {.noconv.} => quit())
  while not window.is_closing():
    window.clear_screen(color.DarkGreen)

    result = result.handle_messages(on_message)
    result = result.update(window.get_delta())
    
    window.begin_draw()
    result.draw(cache)
    window.end_draw()
  exit_proc()
