import komodo/ecs/[
    components,
    entity,
    ids,
]

type
    TestBehavior* = ref object of BehaviorComponent

proc new_test_behavior*(parent: Entity; isEnabled: bool = true): TestBehavior =
    result = TestBehavior(
        id: nextComponentId(),
    )
    result.parent = parent
    result.isEnabled = isEnabled
