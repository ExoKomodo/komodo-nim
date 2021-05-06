import komodo


type
  MoveMessageData* = ref object of DataBag
    translation: Vector3

func translation*(self: MoveMessageData): auto = self.translation

func newMoveMessageData*(translation: Vector3): MoveMessageData =
  MoveMessageData(
    kind: "move",
    translation: translation,
  )
    
func newMoveMessage*(data: MoveMessageData): Message =
  newMessage("move", data)

func translate(entity: Entity; translation: Vector3; velocity: float): Entity =
  result = newEntity(
    data = entity.data,
    drawables = entity.drawables,
    position = entity.position + translation * velocity,
  )

func handle*(entity: Entity; message_data: MoveMessageData, velocity: float): Entity =
  result = entity.translate(message_data.translation, velocity)
  
