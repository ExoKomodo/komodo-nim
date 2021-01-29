import options
import tables

import ../components/[
    component,
    text_component,
    transform_component,
]
import ../entity
import ../../lib/[
    graphics,
    math,
]
import ../../logging
import ./system_macros


func drawComponents(
    text: TextComponent;
    transform: TransformComponent;
) = text.text.drawCentered(
    transform.position,
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

    destroy:
        logInfo("Destroying render text system...")
        logInfo("Destroyed render text system")

method hasNecessaryComponents*(self: RenderTextSystem; entity: Entity; components: seq[Component]): bool =
    if (
        self.findComponentByParent[:TextComponent](entity).isNone() or
        self.findComponentByParent[:TransformComponent](entity).isNone()
    ):
        return false
    true
