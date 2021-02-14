import komodo

import komodo/ecs/[
  components,
  entity,
  systems,
]
import komodo/lib/graphics/color
import komodo/lib/math

import ./move_system


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

proc addBrainlet(game: Game) =
  ##########
  # Entity #
  ##########
  let parent = newEntity()
  assert game.registerEntity(parent)
  assert game.deregisterEntity(parent)
  assert not game.deregisterEntity(parent)
  assert game.registerEntity(parent)

  #############
  # Component #
  #############
  let sprite = newSpriteComponent(
      parent,
      "img/brainlet.png",
      color = White,
  )
  assert game.registerComponent(sprite)
  assert game.deregisterComponent(sprite)
  assert not game.deregisterComponent(sprite)
  assert game.registerComponent(sprite)

  let text = newTextComponent(
      parent,
      "Hello from desktop!",
      fontSize = 24,
      color = Black,
  )
  assert game.registerComponent(text)
  assert game.deregisterComponent(text)
  assert not game.deregisterComponent(text)
  assert game.registerComponent(text)

  let screen_size = game.screenSize()
  let transform = newTransformComponent(
    parent,
    position = Vector3(
        x: screen_size.x / 2,
        y: screen_size.y / 2,
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
  assert game.deregisterComponent(transform)
  assert not game.deregisterComponent(transform)
  assert game.registerComponent(transform)

  ##########
  # System #
  ##########
  let render_sprite_system = newRenderSpriteSystem()
  assert game.registerSystem(render_sprite_system)
  assert game.deregisterSystem(render_sprite_system)
  assert not game.deregisterSystem(render_sprite_system)
  assert game.registerSystem(render_sprite_system)
  
  let render_text_system = newRenderTextSystem()
  assert game.registerSystem(render_text_system)
  assert game.deregisterSystem(render_text_system)
  assert not game.deregisterSystem(render_text_system)
  assert game.registerSystem(render_text_system)

  let move_system = newMoveSystem()
  assert game.registerSystem(move_system)
  assert game.deregisterSystem(move_system)
  assert not game.deregisterSystem(move_system)
  assert game.registerSystem(move_system)

proc main() =
  var game = newGame()
  game.title = "Desktop Example"
  game.clearColor = Blue

  game.addCube()
  game.addBrainlet()

  game.run()

when isMainModule:
  main()
  # Run main twice to test that the engine is idempotent
  main()
