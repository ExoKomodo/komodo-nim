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

    
    let parent = new_entity()
    assert game.register_entity(parent)
    
    assert game.register_system(new_test_behavior_system())
    let behavior = new_test_behavior(
        parent,
    )
    assert game.register_component(behavior)
    
    assert game.register_system(new_render_sprite_system())
    let sprite = new_sprite_component(
        parent,
        "img/brainlet.png",
    )
    assert game.register_component(sprite)
    
    assert game.register_system(new_render_text_system())
    let text = new_text_component(
        parent,
        "Hello from desktop!"
    )
    assert game.register_component(text)

    let screen_size = game.screen_size()
    let transform = new_transform_component(
        parent,
        position=Vector3(
            x: screen_size.x / 2,
            y: screen_size.y / 2,
            z: 0,
        ),
        rotation=Vector3(
            x: 0,
            y: 0,
            z: 0,
        ),
        scale=Vector3(
            x: 0.5,
            y: 0,
            z: 0,
        ),
    )
    assert game.register_component(transform)

    game.run()
