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


  let parent = newEntity()
  assert game.registerEntity(parent)

  assert game.registerSystem(newBehaviorSystem())
  let behavior = newTestBehavior(
      parent,
  )
  assert game.registerComponent(behavior)

  assert game.registerSystem(newRenderSpriteSystem())
  let sprite = newSpriteComponent(
      parent,
      "img/brainlet.png",
      color = White,
  )
  assert game.registerComponent(sprite)

  assert game.registerSystem(newRenderTextSystem())
  let text = newTextComponent(
      parent,
      "Hello from desktop!",
      fontSize = 24,
      color = Black,
  )
  assert game.registerComponent(text)

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
        y: 0,
        z: 0,
    ),
  )
  assert game.registerComponent(transform)

  game.run()

when isMainModule:
  main()
  # Run main twice to test that the engine is idempotent
  main()
