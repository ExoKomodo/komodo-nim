from ./math import nil

import ./actions
import ./entity
import ./message
import ./resource_config

export resource_config


type  
  GameState* = object
    screen_size*: math.Vector2
    title*: string
    action_map*: ActionMap
    entities*: seq[Entity]
    messages*: seq[Message]
    delta*: float32
    resource_config*: ResourceConfig

func height*(self: GameState): auto = self.screen_size.y.int
func width*(self: GameState): auto = self.screen_size.x.int

func newGameState*(
  title: string;
  width: Natural;
  height: Natural;
  action_map: ActionMap;
  delta: float32;
  resource_config: ResourceConfig;
  entities: seq[Entity] = @[];
  messages: seq[Message] = @[];
): auto =
  GameState(
    action_map: action_map,
    delta: delta,
    screen_size: math.Vector2(
      x: width.float,
      y: height.float,
    ),
    title: title,
    entities: entities,
    messages: messages,
    resource_config: resource_config,
  )

