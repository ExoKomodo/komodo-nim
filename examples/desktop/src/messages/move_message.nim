import komodo


type
  MoveMessageData* = ref object of DataBag
    translation: Vector3
    direction: Vector3
    velocity: float

func direction*(self: MoveMessageData): auto = self.direction
func translation*(self: MoveMessageData): auto = self.translation
func velocity*(self: MoveMessageData): auto = self.velocity

func newMoveMessageData*(translation: Vector3): MoveMessageData =
  MoveMessageData(
    kind: "move",
    translation: translation,
  )
    
func newMoveMessage*(data: MoveMessageData): Message =
  newMessage("move", data)

func translate(
  entity: Entity;
  translation: Vector3;
): Entity =
  newEntity(
    data = entity.data,
    drawables = entity.drawables,
    position = entity.position + translation,
  )

func handle*(
  entity: Entity;
  message_data: MoveMessageData;
): Entity =
  result = entity.translate(
    message_data.translation *
    message_data.direction +
    message_data.velocity
  )

