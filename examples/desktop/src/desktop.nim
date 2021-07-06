import komodo
import komodo/[
  logging,
  math,
]
import ./data/brainlet

from os import nil
from sugar import collect

from komodo/macro_helpers import `<-`


func pre_init(initial_state: GameState): GameState =
  result = initial_state.action_map <- newActionMap(
    @[
      newAction(
        brainlet.actions.move_up,
        keyInputs = @[Keys.Up, Keys.W]
      ),
      newAction(
        brainlet.actions.move_down,
        keyInputs = @[Keys.Down, Keys.S],
      ),
      newAction(
        brainlet.actions.move_left,
        keyInputs = @[Keys.Left, Keys.A],
      ),
      newAction(
        brainlet.actions.move_right,
        keyInputs = @[Keys.Right, Keys.D],
      ),
      newAction(
        brainlet.actions.left_click,
        mouseInputs = @[MouseButtons.Left],
      ),
    ]
  )

func init(initial_state: GameState): GameState =
  result = initial_state.entities <- @[
    newBrainlet(
      newBrainletData(1)
    ),
  ]

func on_message(initial_state: GameState; message: Message): GameState =
  result = initial_state
  case message.kind:
  of brainlet.messages.left_click:
    result.entities = block: collect(newSeq):
      for entity in result.entities:
        if entity.has_brainlet_data():
          let (entity, messages) = brainlet.on_message(entity, result, message)
          for message in messages:
            result.messages.add(message)
          entity

func update(entity: Entity; state: GameState): (Entity, GameState) =
  var (entity, state) = (entity, state)
  if entity.has_brainlet_data():
    var messages: seq[Message]
    (entity, messages) = brainlet.update(entity, state)
    for message in messages:
      state.messages.add(message)
  (entity, state)

func update(initial_state: GameState): GameState =
  result = initial_state
  result.entities = block: collect(newSeq):
    for entity in result.entities:
      var entity = entity
      (entity, result) = entity.update(result)
      entity

proc exit(initial_state: GameState) =
  logging.log_info("Exiting desktop example...")
  logging.log_info("Exited desktop example!")

proc main() =
  log_info("Welcome to the desktop example")
  let state = newGameState(
    title = "Komodo",
    width = 800,
    height = 600,
    action_map = newActionMap(),
    entities = @[],
    delta = 0,
    resource_config = newResourceConfig(
      directory = "resources",
    )
  )
  
  discard state.run(
    pre_init,
    init,
    update,
    on_message,
    exit,
  )

when isMainModule:
  main()
  # Run main twice to test that the engine is idempotent
  main()

