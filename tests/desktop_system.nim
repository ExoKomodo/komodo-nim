import options
import sets
import strformat
import tables

import desktop_behavior
import komodo/core
import komodo/ecs/systems
import komodo/logging

type
    DesktopSystem* = ref object of BehaviorSystem

func newDesktopSystem*(): DesktopSystem =
    result = DesktopSystem(
        registeredTypes: toHashSet([DesktopBehaviorTypeId]),
    )
    result.isEnabled = true

func updateComponent(self: DesktopSystem; behavior: DesktopBehavior; delta: float32) =
    logInfo(fmt"Hello from {behavior.id}")

method update*(self: DesktopSystem; delta: float32) =
    for entityId, components in pairs(self.entityToComponents):
        let behavior = self.findComponentByParent[:DesktopBehavior](
            entityId,
            DesktopBehaviorTypeId,
        )
        if behavior.isNone():
            continue
        self.updateComponent(
            behavior.get(),
            delta,
        )
