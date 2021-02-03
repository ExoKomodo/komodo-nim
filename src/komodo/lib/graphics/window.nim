import options

from ../private/raylib import nil

import ../math
import ./color

proc beginDraw*() = raylib.BeginDrawing()

proc clearScreen*(clearColor: Color = White) = raylib.ClearBackground(clearColor)

proc clearScreen*(clearColor: Option[Color]) =
  if clearColor.isSome():
    clearScreen(clearColor.unsafeGet())
  else:
    clearScreen()

proc getDelta*: float32 = raylib.GetFrameTime()

proc close*() = raylib.CloseWindow()

proc endDraw*() = raylib.EndDrawing()

proc initWindow*(screenSize: Vector2; title: string) = raylib.InitWindow(
    int32(screenSize.x),
    int32(screenSize.y),
    title,
)

proc isClosing*: bool = raylib.WindowShouldClose()

proc setFps*(fps: int32) = raylib.SetTargetFPS(fps)

proc setWindowTitle*(title: string) = raylib.SetWindowTitle(title)
