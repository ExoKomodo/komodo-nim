from ./utils/math import nil

import ./entity


type
  GameState* = object
    screen_size*: math.Vector2
    title*: string
    entities*: seq[Entity]

func height*(self: GameState): auto = self.screen_size.y.int
func width*(self: GameState): auto = self.screen_size.x.int

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
