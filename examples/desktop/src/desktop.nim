import komodo/core
import komodo/ecs/entity

import test_behavior_system
import test_behavior

when isMainModule:
    var game = newGame()

    let system = newTestBehaviorSystem()
    assert game.registerSystem(system)
    
    let parent = newEntity()
    assert game.registerEntity(parent)
    
    let behavior = newTestBehavior(
        parent,
    )
    assert game.registerComponent(behavior)
    game.run()
