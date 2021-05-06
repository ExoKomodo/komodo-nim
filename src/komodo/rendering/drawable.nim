type
  DrawableKind* {.pure.} = enum
    image,
    text,
  
  Drawable* = object
    case kind*: DrawableKind
    of image:
      image_path*: string
    of text:
      font_path*: string
      text*: string

