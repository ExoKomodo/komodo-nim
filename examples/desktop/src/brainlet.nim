import komodo
import komodo/rendering


func newBrainlet*(): Entity =
  newEntity(
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

