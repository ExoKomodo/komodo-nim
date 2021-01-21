import komodo/ecs/ids

type
    Entity* = ref object of RootObj
        id*: EntityId

proc newEntity*(): Entity =
    Entity(
        id: nextEntityId(),
    )
