import unittest

import desktop_behavior
import desktop_system
import komodo/core
import komodo/ecs/entity

test "Test game":
    var game = newGame()

    checkpoint("System creation...")
    let desktopSystem = newDesktopSystem()
    checkpoint("Registering system")
    assert game.registerSystem(desktopSystem)
    
    checkpoint("Entity creation...")
    let entity = newEntity()
    checkpoint("Registering entity")
    assert game.registerEntity(entity)
    
    checkpoint("Component creation...")
    let behavior = newDesktopBehavior(
        entity,
    )
    checkpoint("Registering component")
    assert game.registerComponent(behavior)

    checkpoint("Running game...")
    game.run()
