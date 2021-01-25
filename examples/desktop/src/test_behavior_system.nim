import options
import strformat
import tables

import test_behavior
import komodo/ecs/[
    components,
    entity,
    systems,
]
import komodo/logging

type
    TestBehaviorSystem* = ref object of BehaviorSystem

func new_test_behavior_system*(): TestBehaviorSystem =
    result = TestBehaviorSystem()
    result.isEnabled = true

func updateComponent(self: TestBehaviorSystem; behavior: TestBehavior; delta: float32) =
    logInfo(fmt"Hello from {behavior.id}")

method has_necessary_components*(self: RenderTextSystem; entity: Entity; components: seq[Component]): bool =
    if self.find_component_by_parent[:TestBehavior](entity).isNone():
        return false
    true

method update*(self: TestBehaviorSystem; delta: float32) =
    for entityId, components in pairs(self.entity_to_components):
        let behavior = self.find_component_by_parent[:TestBehavior](entityId)
        if behavior.isNone():
            continue
        self.updateComponent(
            behavior.get(),
            delta,
        )
