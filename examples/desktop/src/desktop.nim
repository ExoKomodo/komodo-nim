import komodo

import komodo/ecs/components
import komodo/ecs/entity
import komodo/ecs/systems

import komodo/lib/graphics/color
import komodo/lib/math

import test_behavior

proc main() =
  var game = newGame()
  game.title = "Desktop Example"
  game.clearColor = Blue

  let parent = newEntity()
  assert game.registerEntity(parent)
  assert game.deregisterEntity(parent)
  assert not game.deregisterEntity(parent)
  assert game.registerEntity(parent)

  let behavior_system = newBehaviorSystem()
  assert game.registerSystem(behavior_system)
  let behavior = newTestBehavior(
      parent,
  )
  assert game.registerComponent(behavior)

  let render_sprite_system = newRenderSpriteSystem()
  assert game.registerSystem(render_sprite_system)
  let sprite = newSpriteComponent(
      parent,
      "img/brainlet.png",
      color = White,
  )
  assert game.registerComponent(sprite)

  let render_text_system = newRenderTextSystem()
  assert game.registerSystem(render_text_system)
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

  let render_model_system = newRenderModelSystem()
  assert game.registerSystem(render_model_system)
  let model = newModelComponent(
      parent,
      "models/cube.obj",
      color = White,
  )
  assert game.registerComponent(model)

  let screenSize = game.screenSize()
  let transform = newTransformComponent(
      parent,
      position = Vector3(
          x: screenSize.x / 2,
          y: screenSize.y / 2,
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

  assert game.deregisterSystem(behavior_system)
  assert not game.deregisterSystem(behavior_system)
  assert game.registerSystem(behavior_system)

  game.run()

when isMainModule:
  main()
  # Run main twice to test that the engine is idempotent
  main()
