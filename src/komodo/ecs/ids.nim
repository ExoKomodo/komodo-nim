type
    ComponentId* = int
    EntityId* = int

proc nextComponentId*(): ComponentId =
    var componentId {.global.}: ComponentId = 0
    componentId.inc()
    componentId

proc nextEntityId*(): EntityId =
    var entityId {.global.}: EntityId = 0
    entityId.inc()
    entityId