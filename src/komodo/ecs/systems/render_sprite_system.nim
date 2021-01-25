import options
import tables

import ./system_macros
import ../components/[
    component,
    sprite_component,
    transform_component,
]
import ../entity
import ../../lib/raylib

func drawComponents(
    sprite: SpriteComponent;
    transform: TransformComponent;
) =
    sprite.texture.DrawTextureEx(
        Vector2(
            x: transform.position.x,
            y: transform.position.y,
        ),
        transform.rotation.z,
        transform.scale.x,
        sprite.color,
    )

system RenderSpriteSystem:
    fields:
        discard
    
    create:
        discard

    init:
        discard

    draw:
        for entityId, components in pairs(self.entityToComponents):
            let sprite = self.findComponentByParent[:SpriteComponent](entityId)
            let transform = self.findComponentByParent[:TransformComponent](entityId)
            if sprite.isNone() or transform.isNone():
                continue
            drawComponents(
                sprite.get(),
                transform.get(),
            )

    final:
        discard

method hasNecessaryComponents*(self: RenderSpriteSystem; entity: Entity; components: seq[Component]): bool =
    if (
        self.findComponentByParent[:SpriteComponent](entity).isNone() or
        self.findComponentByParent[:TransformComponent](entity).isNone()
    ):
        return false
    true