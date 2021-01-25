import options
import tables

import ./system
import ../components/[
    component,
    sprite_component,
    transform_component,
]
import ../entity
import ../../lib/raylib

type
    RenderSpriteSystem* = ref object of System

func draw_components(self: RenderSpriteSystem; sprite: SpriteComponent; transform: TransformComponent) =
    sprite.texture.DrawTextureEx(
        Vector2(
            x: transform.position.x,
            y: transform.position.y,
        ),
        transform.rotation.z,
        transform.scale.x,
        sprite.color,
    )

func new_render_sprite_system*(): RenderSpriteSystem =
    result = RenderSpriteSystem()
    result.isEnabled = true

method has_necessary_components*(self: RenderSpriteSystem; entity: Entity; components: seq[Component]): bool =
    if (
        self.find_component_by_parent[:SpriteComponent](entity).isNone() or
        self.find_component_by_parent[:TransformComponent](entity).isNone()
    ):
        return false
    true

method initialize*(self: RenderSpriteSystem) =
    procCall self.System.initialize()

method draw*(self: RenderSpriteSystem) =
    for entity_id, components in pairs(self.entity_to_components):
        let sprite = self.find_component_by_parent[:SpriteComponent](entity_id)
        let transform = self.find_component_by_parent[:TransformComponent](entity_id)
        if sprite.isNone() or transform.isNone():
            continue
        self.draw_components(
            sprite.get(),
            transform.get(),
        )