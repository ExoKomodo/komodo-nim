import komodo
import komodo/rendering
import komodo/utils/math


const BRAINLET_KIND* = "brainlet".DataKind

type
  BrainletData* = ref object of DataBag
    velocity: float32

func has_brainlet_data*(entity: Entity): bool = entity.data.kind == BRAINLET_KIND

func velocity*(self: BrainletData): auto = self.velocity

func newBrainletData*(velocity: float): BrainletData =
  BrainletData(
    kind: BRAINLET_KIND,
    velocity: velocity,
  )

func newBrainlet*(data: BrainletData): Entity =
  newEntity(
    data = data,
    drawables = @[
      Drawable(
        kind: DrawableKind.image,
        image_path: "img/brainlet.png",
      ),
      Drawable(
        kind: DrawableKind.text,
        font_path: "font path",
        text: "Hello world!",
      ),
    ],
    position = Vector3(
      x: 100,
      y: 10,
      z: 0,
    ),
  )

const
  UP = "up".ActionId
  DOWN = "down".ActionId
  LEFT = "left".ActionId
  RIGHT = "right".ActionId

func get_move_direction(actions: ActionMap): Vector3 =
  result = Vector3()
  if actions.isDown(UP):
    result += math.vector3.UP
  if actions.isDown(DOWN):
    result += math.vector3.DOWN
  
  if actions.isDown(LEFT):
    result += math.vector3.LEFT
  if actions.isDown(RIGHT):
    result += math.vector3.RIGHT

func update*(entity: Entity; state: GameState): Entity =
  result = entity
  if entity.has_brainlet_data():
    let data = entity.data.BrainletData
    result = newEntity(
      data = entity.data,
      drawables = entity.drawables,
      position = entity.position + state.actions.get_move_direction() * data.velocity,
    )

