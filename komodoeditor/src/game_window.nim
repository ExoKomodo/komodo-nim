include komodo/prelude

import komodo/ecs/components
import komodo/ecs/systems

proc addCube(game: Game) =
  let parent = newEntity()
  assert game.registerEntity(parent)
  let render_model_system = newRenderModelSystem()
  assert game.registerSystem(render_model_system)
  let model = newModelComponent(
      parent,
      "models/cube.obj",
  )
  model.color = Yellow
  model.hasWireframe = true
  assert game.registerComponent(model)

  let transform = newTransformComponent(
    parent,
    position = Vector3(
        x: -4,
        y: 1,
        z: 0,
    ),
    rotation = Vector3(
        x: 0,
        y: 0,
        z: 0,
    ),
    scale = Vector3(
        x: 0.5,
        y: 1,
        z: 1,
    ),
  )
  assert game.registerComponent(transform)

proc start*(channel: ptr Channel[CommandKind]) =
  var game = newGame()
  game.title = "Komodo Editor Game Window"
  game.clearColor = Blue

  # game.addCube()

  game.run(channel)
