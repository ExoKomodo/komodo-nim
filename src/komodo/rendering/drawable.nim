import ../color
import ../math


type
  DrawableKind* {.pure.} = enum
    image,
    text,
    shape,
  
  Drawable* = object
    case kind*: DrawableKind
    of image:
      image_path*: string
    of text:
      font_path*: string
      text*: string
      font_size*: float32
      font_spacing*: float32
      font_color*: Color
    of shape:
      shape*: Shape

  ShapeKind* {.pure.} = enum
    circle,
    line,
    rectangle,
  
  Shape* = object
    color*: Color

    case kind*: ShapeKind
    of line:
      start_point*: Vector2
      end_point*: Vector2
      thickness*: float32
    of circle:
      center*: Vector2
      radius*: float32
    of rectangle:
      rect*: Rectangle
      rotation*: float32

