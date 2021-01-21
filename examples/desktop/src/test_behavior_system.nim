import options
import sets
import strformat
import tables

import test_behavior
import komodo/core
import komodo/ecs/systems
import komodo/logging

type
    TestBehaviorSystem* = ref object of BehaviorSystem

func newTestBehaviorSystem*(): TestBehaviorSystem =
    result = TestBehaviorSystem(
        registeredTypes: toHashSet([TestBehaviorTypeId]),
    )
    result.isEnabled = true

func updateComponent(self: TestBehaviorSystem; behavior: TestBehavior; delta: float32) =
    logInfo(fmt"Hello from {behavior.id}")

method update*(self: TestBehaviorSystem; delta: float32) =
    for entityId, components in pairs(self.entityToComponents):
        let behavior = self.findComponentByParent[:TestBehavior](
            entityId,
            TestBehaviorTypeId,
        )
        if behavior.isNone():
            continue
        self.updateComponent(
            behavior.get(),
            delta,
        )
