import komodo/core
import komodo/ecs/[
    components,
    entity,
]

type
    TestBehavior* = ref object of BehaviorComponent

const TestBehaviorTypeId* = "TestBehavior"

proc newTestBehavior*(parent: Entity; isEnabled: bool = true): TestBehavior =
    result = TestBehavior(
        id: nextComponentId(),
    )
    result.parent = parent
    result.isEnabled = isEnabled

method typeId*(self: TestBehavior): string = TestBehaviorTypeId
