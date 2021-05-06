import komodo
import komodo/macro_helpers
import komodo/utils/[
  logging,
  math,
]
import ./brainlet
import ./messages

from sugar import collect


func pre_init(initial_state: GameState): GameState =
  result = initial_state

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
    result = result.entities <- (
      block: collect(newSeq):
        for entity in result.entities:
          let data = entity.data
          if data.kind == "brainlet":
            entity.handle(move_message_data, entity.data.BrainletData.velocity)
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

