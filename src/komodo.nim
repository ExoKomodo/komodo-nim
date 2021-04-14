from komodo/lib/color import nil
from komodo/lib/math import nil
from komodo/lib/window import nil


type GameState* = object of RootObj
  screen_size: math.Vector2
  title: string

func screen_size*(self: GameState): auto = self.screen_size
func title*(self: GameState): auto = self.title

func newGameState*(
  title: string,
  width: Natural,
  height: Natural;
): GameState =
  GameState(
    screen_size: math.Vector2(
      x: width.float,
      y: height.float,
    ),
    title: title,
  )

func run*(
  initial_state: GameState;
  init: proc(state: GameState): GameState {.noSideEffect.};
  post_init: proc(state: GameState): GameState {.noSideEffect.};
  update: proc(state: GameState; delta: float): GameState {.noSideEffect.};
  exit: proc(state: GameState) {.noSideEffect.};
) =
  var state = initial_state.init()
  window.initialize(
    state.screenSize,
    state.title,
  )
  state = state.post_init()
  
  while not window.is_closing():
    window.clear_screen(color.DarkGreen)
    window.begin_draw()
    state = state.update(window.get_delta())
    window.end_draw()
  
  state.exit()
