import options

from ../private/raylib import BeginDrawing, ClearBackground, CloseWindow, EndDrawing, GetFrameTime, InitWindow, SetTargetFPS, SetWindowTitle, WindowShouldClose

import ../math
import ./color

proc beginDraw*() = BeginDrawing()

proc clearScreen*(clearColor: Color=White) = ClearBackground(clearColor)

proc clearScreen*(clearColor: Option[Color]) =
    if clearColor.isSome():
        clearScreen(clearColor.unsafeGet())
    else:
        clearScreen()

proc getDelta*: float32 = GetFrameTime()

proc close*() = CloseWindow()

proc endDraw*() = EndDrawing()

proc initWindow*(screenSize: Vector2; title: string) = InitWindow(
    int32(screenSize.x),
    int32(screenSize.y),
    title,
)

proc isClosing*: bool = WindowShouldClose()

proc setFps*(fps: int32) = SetTargetFPS(fps)

proc setWindowTitle*(title: string) = SetWindowTitle(title)
