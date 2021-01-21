import options
import sets
import tables

import komodo/ecs/systems/system
import komodo/ecs/components/[
    text_component,
    transform_component,
]
import komodo/lib/raylib

func getCenterOffset(text: cstring; fontSize: int32): int32 =
    MeasureText(text, fontSize) div 2

func drawCenteredText(text: cstring; position: Vector2; fontSize: int32; color: Color) =
    DrawText(
        text,
        int32(position.x) - text.getCenterOffset(fontSize),
        int32(position.y),
        fontSize,
        color,
    )

type
    RenderTextSystem* = ref object of System

func drawComponent(self: RenderTextSystem; text: TextComponent; transform: TransformComponent) =
    text.text.drawCenteredText(
        Vector2(
            x: transform.position().x,
            y: transform.position().y,
        ),
        text.fontSize,
        text.color,
    )

func newRenderTextSystem*(): RenderTextSystem =
    result = RenderTextSystem(
        registeredTypes: toHashSet(
            [
                TextComponentTypeId,
                TransformComponentTypeId,
            ]
        ),
    )
    result.isEnabled = true

method initialize*(self: RenderTextSystem) =
    procCall self.System.initialize()

method draw*(self: RenderTextSystem) =
    for entityId, components in pairs(self.entityToComponents):
        let text = self.findComponentByParent[:TextComponent](
            entityId,
            TextComponentTypeId,
        )
        let transform = self.findComponentByParent[:TransformComponent](
            entityId,
            TransformComponentTypeId,
        )
        if text.isNone() or transform.isNone():
            continue
        self.drawComponent(
            text.get(),
            transform.get(),
        )