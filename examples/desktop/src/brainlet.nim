import komodo
import komodo/rendering

type
  BrainletData* = ref object of DataBag
    velocity: float32

func velocity*(self: BrainletData): auto = self.velocity

func newBrainletData*(velocity: float): BrainletData =
  BrainletData(
    kind: "brainlet",
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


