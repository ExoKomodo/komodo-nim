import ./lib/math/vector3
import ./rendering/drawable


type
  EntityObj = object of RootObj
    drawables: seq[Drawable]
    position: Vector3
  Entity* = ref EntityObj

func drawables*(self: Entity): auto = self.drawables
func position*(self: Entity): auto = self.position

func newEntity*(
  drawables: seq[Drawable];
  position: Vector3 = Vector3();
): auto =
  Entity(
    drawables: drawables,
    position: position,
  )
