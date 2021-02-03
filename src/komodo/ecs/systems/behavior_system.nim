import options
import tables

import ./system_macros
import ../components/behavior_component
import ../../logging
import ./system

system BehaviorSystem:
  fields:
    discard

  create:
    discard

  init:
    discard

  update:
    for entityId, components in pairs(self.entityToComponents):
      let behavior = self.findComponentByParent[:BehaviorComponent](entityId)
      if behavior.isNone():
        continue
      behavior.get().update(delta)

  destroy:
    logInfo("Destroying behavior system...")
    logInfo("Destroyed behavior system")
