{.experimental: "codeReordering".}

import ../color
import ../math


type
  DrawableKind* {.pure.} = enum
    image,
    text,
    shape,
  
  Drawable* = object
    case kind: DrawableKind
    of DrawableKind.image:
      image_path: string
    of DrawableKind.shape:
      shape: Shape
    of DrawableKind.text:
      font_color: Color
      font_path: string
      font_size: float
      font_spacing: float32
      text: string

func kind*(self: Drawable): auto = self.kind

#########
# Image #
#########
func image_path*(self: Drawable): auto = self.image_path

func newDrawableImage*(
  path: string;
): Drawable =
  Drawable(
    kind: DrawableKind.image,
    image_path: path,
  )

#########
# Shape #
#########
func shape*(self: Drawable): auto = self.shape

func newDrawableShape*(
  shape: Shape;
): Drawable =
  Drawable(
    kind: DrawableKind.shape,
    shape: shape,
  )

########
# Text #
########
func font_color*(self: Drawable): auto = self.font_color
func font_path*(self: Drawable): auto = self.font_path
func font_size*(self: Drawable): auto = self.font_size
func font_spacing*(self: Drawable): auto = self.font_spacing
func text*(self: Drawable): auto = self.text

func newDrawableText*(
  text: string;
  size: float=12;
  spacing: float=1;
  color: Color=Black;
): Drawable =
  Drawable(
    kind: DrawableKind.text,
    text: text,
    font_size: size,
    font_spacing: spacing,
    font_color: color,
  )

type
  ShapeKind* {.pure.} = enum
    circle,
    line,
    rectangle,
  
  Shape* = object
    color: Color

    case kind: ShapeKind
    of ShapeKind.circle:
      center: Vector2
      radius: float
    of ShapeKind.line:
      end_point: Vector2
      start_point: Vector2
      thickness: float
    of ShapeKind.rectangle:
      rect: Rectangle
      rotation: float

func color*(self: Shape): auto = self.color
func kind*(self: Shape): auto = self.kind

##########
# Circle #
##########
func center*(self: Shape): auto = self.center
func radius*(self: Shape): auto = self.radius

func newCircle*(
  center: Vector2=Vector2();
  radius: float=1;
  color: Color=White;
): Shape =
  Shape(
    kind: ShapeKind.circle,
    center: center,
    radius: radius,
    color: color,
  )

########
# Line #
########
func end_point*(self: Shape): auto = self.end_point
func start_point*(self: Shape): auto = self.start_point
func thickness*(self: Shape): auto = self.thickness

func newLine*(
  end_point: Vector2;
  start_point: Vector2;
  thickness: float=1;
): Shape = 
  Shape(
    kind: ShapeKind.line,
    end_point: end_point,
    start_point: start_point,
    thickness: thickness,
  )

#############
# Rectangle #
#############
func rect*(self: Shape): auto = self.rect
func rotation*(self: Shape): auto = self.rotation

func newRectangle*(
  rect: Rectangle;
  rotation: float=0;
): Shape = 
  Shape(
    kind: ShapeKind.rectangle,
    rect: rect,
    rotation: rotation,
  )

