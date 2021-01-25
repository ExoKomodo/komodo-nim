import options
import tables

import ./system_macros
import ../components/[
    component,
    text_component,
    transform_component,
]
import ../entity
import ../../lib/raylib

func getCenterOffset(
    text: cstring;
    fontSize: int32;
): int32 = MeasureText(text, fontSize) div 2

func drawCenteredText(
    text: cstring;
    position: Vector2;
    fontSize: int32;
    color: Color;
) = DrawText(
    text,
    int32(position.x) - text.getCenterOffset(fontSize),
    int32(position.y),
    fontSize,
    color,
)

func drawComponents(
    text: TextComponent;
    transform: TransformComponent;
) = text.text.drawCenteredText(
    Vector2(
        x: transform.position().x,
        y: transform.position().y,
    ),
    text.fontSize,
    text.color,
)

system RenderTextSystem:
    fields:
        discard
    
    create:
        discard

    init:
        discard

    draw:
        for entityId, components in pairs(self.entityToComponents):
            let text = self.findComponentByParent[:TextComponent](entityId)
            let transform = self.findComponentByParent[:TransformComponent](entityId)
            if text.isNone() or transform.isNone():
                continue
            drawComponents(
                text.get(),
                transform.get(),
            )

    final:
        discard

method hasNecessaryComponents*(self: RenderTextSystem; entity: Entity; components: seq[Component]): bool =
    if (
        self.findComponentByParent[:TextComponent](entity).isNone() or
        self.findComponentByParent[:TransformComponent](entity).isNone()
    ):
        return false
    true
