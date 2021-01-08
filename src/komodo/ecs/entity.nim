type
    EntityId* = int
    Entity* = ref object of RootObj
        id*: EntityId

proc nextEntityId(): EntityId {.inline.} =
    var nextId {.global.}: EntityId = 0
    nextId.inc()
    nextId

proc newEntity*(): Entity =
    Entity(
        id: nextEntityId(),
    )
