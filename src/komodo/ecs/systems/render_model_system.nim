import options
import tables

import ./system_macros
import ../components/[
    component,
    model_component,
    transform_component,
]
import ../entity
import ../../lib/graphics/model3d
import ../../logging

func drawComponents(
    model: ModelComponent;
    transform: TransformComponent;
) =
  model.model.draw(
      transform.position,
      transform.rotation,
      transform.scale,
      model.color,
  )

system RenderModelSystem:
  fields:
    discard

  create:
    discard

  init:
    discard

  draw:
    for entityId, components in pairs(self.entityToComponents):
      let model = self.findComponentByParent[:ModelComponent](entityId)
      let transform = self.findComponentByParent[:TransformComponent](entityId)
      if model.isNone() or transform.isNone():
        continue
      drawComponents(
          model.get(),
          transform.get(),
      )

  destroy:
    logInfo("Destroying render model system...")
    logInfo("Destroyed render model system")

method hasNecessaryComponents*(
    self: RenderModelSystem;
    entity: Entity;
    components: seq[Component];
): bool =
  if (
      self.findComponentByParent[:ModelComponent](entity).isNone() or
      self.findComponentByParent[:TransformComponent](entity).isNone()
  ):
    return false
  true
