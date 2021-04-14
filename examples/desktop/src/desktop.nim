import komodo
import komodo/lib/logging

import strformat


func init(state: GameState): GameState =
  result = state

func post_init(state: GameState): GameState =
  result = state

func update(state: GameState; delta: float): GameState =
  result = state
  
  log_info(fmt"Delta: {delta}")

func exit(state: GameState) =
  discard

proc main() =
  echo "Something"
  let state = newGameState(
    title = "Komodo",
    width = 800,
    height = 600,
  )
  
  state.run(
    init,
    post_init,
    update,
    exit,
  )

when isMainModule:
  main()
  # Run main twice to test that the engine is idempotent
  main()
