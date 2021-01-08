import komodo/core
import komodo/ecs/[
    components,
    entity,
    systems,
]

type
    DesktopBehavior* = ref object of BehaviorComponent

const DesktopBehaviorTypeId* = "DesktopBehavior"

proc newDesktopBehavior*(parent: Entity; isEnabled: bool = true): DesktopBehavior =
    result = DesktopBehavior(
        id: nextComponentId(),
    )
    result.parent = parent
    result.isEnabled = isEnabled

method typeId*(self: DesktopBehavior): string = DesktopBehaviorTypeId
