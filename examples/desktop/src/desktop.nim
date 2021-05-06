import komodo
import komodo/macro_helpers
import komodo/utils/[
  logging,
  math,
]
import komodo/utils/math/vector_operations
import ./brainlet
import ./messages

from sugar import collect


const
  UP = "up".ActionId
  DOWN = "down".ActionId
  LEFT = "left".ActionId
  RIGHT = "right".ActionId

func get_move_direction(actions: ActionMap): Vector3 =
  result = Vector3()
  if actions.isDown(UP):
    result += math.vector3.UP
  if actions.isDown(DOWN):
    result += math.vector3.DOWN
  
  if actions.isDown(LEFT):
    result += math.vector3.LEFT
  if actions.isDown(RIGHT):
    result += math.vector3.RIGHT

func pre_init(initial_state: GameState): GameState =
  result = initial_state.actions <- newActionMap(
    @[
      newAction(
        UP,
        @[Keys.Up, Keys.W]
      ),
      newAction(
        DOWN,
        @[Keys.Down, Keys.S],
      ),
      newAction(
        LEFT,
        @[Keys.Left, Keys.A],
      ),
      newAction(
        RIGHT,
        @[Keys.Right, Keys.D],
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
  
  if message.kind == "move":
    let move_message_data = message.data.MoveMessageData
    let direction = result.actions.get_move_direction()
    result = result.entities <- (
      block: collect(newSeq):
        for entity in result.entities:
          let data = entity.data
          if data.kind == "brainlet":
            entity.handle(move_message_data, direction, entity.data.BrainletData.velocity)
    )

func update(initial_state: GameState; delta: float): GameState =
#   logging.log_info($delta)
  result = initial_state
  result.messages.add(
    newMoveMessage(
      newMoveMessageData(
        translation=Vector3(x: 100, y: 100, z: 0) * delta,
      )
    )
  )

proc exit(initial_state: GameState) =
  logging.log_info("Exiting desktop example...")
  logging.log_info("Exited desktop example!")

proc main() =
  log_info("Welcome to the desktop example")
  let state = newGameState(
    title = "Komodo",
    width = 800,
    height = 600,
    actions = newActionMap(),
    entities = @[],
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

