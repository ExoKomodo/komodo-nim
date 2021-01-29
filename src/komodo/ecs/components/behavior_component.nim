import ./component_macros


component BehaviorComponent:
    fields:
        discard
    
    create:
        discard

    init:
        discard

    destroy:
        discard

method update*(self: BehaviorComponent; delta: float32) {.base.} =
    discard
