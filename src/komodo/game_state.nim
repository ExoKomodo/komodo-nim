from komodo/lib/math import nil

import komodo/entity


type
  GameStateObj = object of RootObj
    screen_size: math.Vector2
    title: string
    entities: seq[Entity]
  GameState* = ref GameStateObj

func entities*(self: GameState): auto = self.entities
func height*(self: GameState): auto = self.screen_size.y.int
func width*(self: GameState): auto = self.screen_size.x.int
func screen_size*(self: GameState): auto = self.screen_size
func title*(self: GameState): auto = self.title

func newGameState*(
  title: string;
  width: Natural;
  height: Natural;
  entities: seq[Entity];
): auto =
  GameState(
    screen_size: math.Vector2(
      x: width.float,
      y: height.float,
    ),
    title: title,
    entities: entities,
  )