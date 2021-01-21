import komodo/ecs/components/component

type
    BehaviorComponent* = ref object of Component

const BehaviorComponentTypeId* = "BehaviorComponent"

method initialize*(self: BehaviorComponent) =
    procCall self.Component.initialize()

method update*(self: BehaviorComponent; delta: float32) {.base.} =
    discard

method typeId*(self: BehaviorComponent): string = BehaviorComponentTypeId
