import options
import tables

import ./system
import ../components/[
    component,
    text_component,
    transform_component,
]
import ../entity
import ../../lib/raylib

func get_center_offset(text: cstring; fontSize: int32): int32 =
    MeasureText(text, fontSize) div 2

func draw_centered_text(text: cstring; position: Vector2; fontSize: int32; color: Color) =
    DrawText(
        text,
        int32(position.x) - text.get_center_offset(fontSize),
        int32(position.y),
        fontSize,
        color,
    )

type
    RenderTextSystem* = ref object of System

func draw_components(self: RenderTextSystem; text: TextComponent; transform: TransformComponent) =
    text.text.draw_centered_text(
        Vector2(
            x: transform.position().x,
            y: transform.position().y,
        ),
        text.fontSize,
        text.color,
    )

func new_render_text_system*(): RenderTextSystem =
    result = RenderTextSystem()
    result.isEnabled = true

method has_necessary_components*(self: RenderTextSystem; entity: Entity; components: seq[Component]): bool =
    if (
        self.find_component_by_parent[:TextComponent](entity).isNone() or
        self.find_component_by_parent[:TransformComponent](entity).isNone()
    ):
        return false
    true

method initialize*(self: RenderTextSystem) =
    procCall self.System.initialize()

method draw*(self: RenderTextSystem) =
    for entityId, components in pairs(self.entity_to_components):
        let text = self.find_component_by_parent[:TextComponent](entityId)
        let transform = self.find_component_by_parent[:TransformComponent](entityId)
        if text.isNone() or transform.isNone():
            continue
        self.draw_components(
            text.get(),
            transform.get(),
        )