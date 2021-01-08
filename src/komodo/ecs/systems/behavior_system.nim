import system

type
    BehaviorSystem* = ref object of System

method initialize*(self: BehaviorSystem) =
    procCall self.System.initialize()

method update*(self: BehaviorSystem; delta: float32) =
    discard
