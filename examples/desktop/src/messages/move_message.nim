import komodo
import komodo/macro_helpers


type
  MoveMessageData* = ref object of MessageData
    translation*: Vector3
    
func newMoveMessage*(data: MoveMessageData): Message =
  newMessage("move", data)

func move(entity: Entity; translation: Vector3): Entity =
  result = entity.position <- Vector3(
    x: entity.position.x + translation.x,
    y: entity.position.y + translation.y,
    z: entity.position.z + translation.z,
  )

func handle*(entity: Entity; message_data: MoveMessageData): Entity =
  result = entity.move(message_data.translation)

