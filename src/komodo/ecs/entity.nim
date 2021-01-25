import ./ids

type
    Entity* = ref object of RootObj
        id*: EntityId

proc new_entity*(): Entity =
    Entity(
        id: nextEntityId(),
    )
