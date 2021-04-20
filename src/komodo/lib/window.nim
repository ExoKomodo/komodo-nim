import options

from ./private/raylib import nil

import ./math
import ./color

proc begin_draw*() = raylib.BeginDrawing()

proc clear_screen*(clear_color: Color = White) =
  raylib.ClearBackground(clear_color)

proc clear_screen*(clear_color: Option[Color]) =
  clearScreen(clear_color.get(White))

proc close*() = raylib.CloseWindow()

proc end_draw*() = raylib.EndDrawing()

proc get_delta*: float32 = raylib.GetFrameTime()

proc get_fps*: int32 = raylib.GetFPS()

proc initialize*(screen_size: Vector2D; title: string) = raylib.InitWindow(
    int32(screen_size.x),
    int32(screen_size.y),
    title,
)

proc is_closing*: bool = raylib.WindowShouldClose()

proc set_fps*(fps: int32) = raylib.SetTargetFPS(fps)

proc set_window_title*(title: string) = raylib.SetWindowTitle(title)
