import komodo
import komodo/macro_helpers
import komodo/utils/[
  logging,
  math,
]
import ./brainlet
import ./messages

import sugar

func pre_init(initial_state: GameState): GameState =
  result = initial_state

func init(initial_state: GameState): GameState =
  result = initial_state.entities <- @[
    newBrainlet(),
  ]

func on_message(initial_state: GameState; message: Message): GameState =
  result = initial_state
  
  if message.kind == "move":
    let move_message_data = MoveMessageData(message.data)
    result = result.entities <- (
      block: collect(newSeq):
        for entity in result.entities:
          entity.handle(move_message_data)
    )

func update(initial_state: GameState; delta: float): GameState =
  result = initial_state
  result.messages.add(
    newMoveMessage(
      MoveMessageData(
        translation: Vector3(x: 100, y: 100, z: 0) * delta,
      )
    )
  )

func exit(initial_state: GameState): GameState =
  result = initial_state

proc main() =
  log_info("Welcome to the desktop example!")
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

