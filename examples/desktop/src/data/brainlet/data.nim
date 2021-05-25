import komodo
import komodo/color
import komodo/logging
import komodo/math
import komodo/rendering

import ./actions as brainlet_actions
import ./messages as brainlet_messages


const brainlet_kind* = "brainlet".DataKind

type
  BrainletData* = ref object of DataBag
    velocity: float32

func has_brainlet_data*(entity: Entity): bool = entity.data.kind == brainlet_kind

func velocity*(self: BrainletData): auto = self.velocity

func newBrainletData*(velocity: float): BrainletData =
  BrainletData(
    kind: brainlet_kind,
    velocity: velocity,
  )

func newBrainlet*(
  data: BrainletData;
  position: Vector3=Vector3();
): Entity =
  newEntity(
    data = data,
    drawables = @[
      newDrawableImage(
        path="img/brainlet.png",
      ),
      newDrawableText(
        text="Brainlet",
        size=48,
        color=Red,
      ),
      newDrawableShape(
        newCircle(
          center=Vector2(x: 225, y: 50),
          radius=50,
          color=Blue,
        ),
      ),
    ],
    position = position,
  )

func generate_messages(entity: Entity; state: GameState): seq[Message] =
  result = @[]
  if state.action_map.isDown(brainlet_actions.left_click):
    result.add(brainlet_messages.newLeftClickMessage(state.delta))

func get_move_direction(action_map: ActionMap): Vector3 =
  result = Vector3()
  if action_map.isDown(brainlet_actions.move_up):
    result += math.vector3.UP
  if action_map.isDown(brainlet_actions.move_down):
    result += math.vector3.DOWN
  
  if action_map.isDown(brainlet_actions.move_left):
    result += math.vector3.LEFT
  if action_map.isDown(brainlet_actions.move_right):
    result += math.vector3.RIGHT

func on_message*(entity: Entity; state: GameState; message: Message): (Entity, seq[Message]) =
  var (entity, messages) = (entity, newSeq[Message]())
  case message.kind:
  of brainlet_messages.left_click:
    logging.log_info($(1.0 / message.data.TimeData.delta))
  (entity, messages)

func update*(entity: Entity; state: GameState): (Entity, seq[Message]) =
  result = (entity, @[])
  if entity.has_brainlet_data():
    let data = entity.data.BrainletData
    let messages = entity.generate_messages(state)
    result = (
      newEntity(
        data = entity.data,
        drawables = entity.drawables,
        position = entity.position + state.action_map.get_move_direction() * data.velocity,
      ),
      messages,
    )
 
