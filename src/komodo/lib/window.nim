import options

from ./private/raylib import nil

import ./math
import ./color

func begin_draw*() = raylib.BeginDrawing()

func clear_screen*(clearColor: Color = White) =
  raylib.ClearBackground(clearColor)

func clear_screen*(clearColor: Option[Color]) =
  clearScreen(clearColor.get(White))

func get_delta*: float32 = raylib.GetFrameTime()

func get_fps*: int32 = raylib.GetFPS()

func close*() = raylib.CloseWindow()

func end_draw*() = raylib.EndDrawing()

func initialize*(screenSize: Vector2D; title: string) = raylib.InitWindow(
    int32(screenSize.x),
    int32(screenSize.y),
    title,
)

func is_closing*: bool = raylib.WindowShouldClose()

func set_fps*(fps: int32) = raylib.SetTargetFPS(fps)

func set_window_title*(title: string) = raylib.SetWindowTitle(title)
