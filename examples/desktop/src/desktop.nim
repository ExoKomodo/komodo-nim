import komodo

import komodo/ecs/components
import komodo/ecs/entity
import komodo/ecs/systems

import komodo/lib/raylib

import test_behavior_system
import test_behavior

when isMainModule:
    var game = newGame()
    game.title = "Desktop Example"

    assert game.registerSystem(newTestBehaviorSystem())

    assert game.registerSystem(newRenderTextSystem())
    
    let parent = newEntity()
    assert game.registerEntity(parent)
    
    let behavior = newTestBehavior(
        parent,
    )
    assert game.registerComponent(behavior)
    
    let text = newTextComponent(
        parent,
        "Hello from desktop!"
    )
    assert game.registerComponent(text)

    let screenSize = game.screenSize()
    let transform = newTransformComponent(
        parent,
        position=Vector3(
            x: screenSize.x / 2,
            y: screenSize.y / 2,
            z: 0,
        ),
        rotation=Vector3(
            x: 0,
            y: 0,
            z: 0,
        ),
        scale=Vector3(
            x: 0,
            y: 0,
            z: 0,
        ),
    )
    assert game.registerComponent(transform)

    game.run()
