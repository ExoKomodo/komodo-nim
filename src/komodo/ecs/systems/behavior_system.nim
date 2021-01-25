import options
import tables

import ../components/behavior_component
import ./system_macros

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

    final:
        discard
