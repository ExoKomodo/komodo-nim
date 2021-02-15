import options

from ../private/raylib import nil

import ../math
import ./color

func beginDraw*() = raylib.BeginDrawing()

func clearScreen*(clearColor: Color = White) =
  raylib.ClearBackground(clearColor)

func clearScreen*(clearColor: Option[Color]) =
  clearScreen(clearColor.get(White))

func getDelta*: float32 = raylib.GetFrameTime()

func getFps*: int32 = raylib.GetFPS()

func close*() = raylib.CloseWindow()

func endDraw*() = raylib.EndDrawing()

func initWindow*(screenSize: Vector2; title: string) = raylib.InitWindow(
    int32(screenSize.x),
    int32(screenSize.y),
    title,
)

func isClosing*: bool = raylib.WindowShouldClose()

func setFps*(fps: int32) = raylib.SetTargetFPS(fps)

func setWindowTitle*(title: string) = raylib.SetWindowTitle(title)
