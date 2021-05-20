import komodo
import komodo/macro_helpers
import komodo/utils/[
  logging,
  math,
]
import ./data/brainlet


func pre_init(initial_state: GameState): GameState =
  result = initial_state.actions <- newActionMap(
    @[
      newAction(
        brainlet.actions.move_up,
        @[Keys.Up, Keys.W]
      ),
      newAction(
        brainlet.actions.move_down,
        @[Keys.Down, Keys.S],
      ),
      newAction(
        brainlet.actions.move_left,
        @[Keys.Left, Keys.A],
      ),
      newAction(
        brainlet.actions.move_right,
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

func update(entity: Entity; state: GameState; delta: float): Entity =
  result = entity
  if result.has_brainlet_data():
    result = brainlet.update(result, state)

func update(initial_state: GameState; delta: float): GameState =
  result = initial_state
  var entities = newSeq[Entity]()
  for entity in result.entities:
    entities.add(entity.update(result, delta))
  result.entities = entities

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

