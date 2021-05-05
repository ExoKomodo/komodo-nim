from ./utils/math import nil

import ./entity
import ./message


type
  GameState* = object
    screen_size*: math.Vector2
    title*: string
    entities*: seq[Entity]
    messages*: seq[Message]

func height*(self: GameState): auto = self.screen_size.y.int
func width*(self: GameState): auto = self.screen_size.x.int

func newGameState*(
  title: string;
  width: Natural;
  height: Natural;
  entities: seq[Entity] = @[];
  messages: seq[Message] = @[];
): auto =
  GameState(
    screen_size: math.Vector2(
      x: width.float,
      y: height.float,
    ),
    title: title,
    entities: entities,
    messages: messages,
  )
