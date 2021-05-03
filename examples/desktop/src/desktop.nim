import komodo
import komodo/macro_helpers
import komodo/rendering
import komodo/utils/[
  logging,
  math,
]

import strformat
import sugar


func move(entity: Entity; translation: Vector3): Entity =
  result = entity.position <| Vector3(
    x: entity.position.x + translation.x,
    y: entity.position.y + translation.y,
    z: entity.position.z + translation.z,
  )

func pre_init(initial_state: GameState): GameState =
  result = initial_state

func init(initial_state: GameState): GameState =
  result = initial_state.entities <| @[
    newEntity(
      drawables = @[
        Drawable(
          kind: DrawableKind.image,
          image_path: "img/brainlet.png",
        ),
        Drawable(
          kind: DrawableKind.text,
          font_path: "font path",
          text: "Hello world!",
        ),
      ],
      position = Vector3(
        x: 100,
        y: 10,
        z: 0,
      ),
    )
  ]

func update(initial_state: GameState; delta: float): GameState =
  result = initial_state
  
  log_debug(fmt"Delta: {delta}")
  
  result = initial_state.entities <| (
    block: collect(newSeq):
      for entity in initial_state.entities:
        entity.move(Vector3(x: 1, y: 0, z: 0))
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
    exit,
  )

when isMainModule:
  main()
  # Run main twice to test that the engine is idempotent
  main()

