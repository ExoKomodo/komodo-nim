import ./component

type
    BehaviorComponent* = ref object of Component

method initialize*(self: BehaviorComponent) =
    procCall self.Component.initialize()

method update*(self: BehaviorComponent; delta: float32) {.base.} =
    discard
