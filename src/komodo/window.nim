import options

from ./private/raylib import nil

import ./math
import ./color

proc begin_draw*() {.sideEffect.} = raylib.BeginDrawing()

proc clear_screen*(clear_color: Color = White) {.sideEffect.} =
  raylib.ClearBackground(clear_color)

proc clear_screen*(clear_color: Option[Color]) {.sideEffect.} =
  clearScreen(clear_color.get(White))

proc close*() {.sideEffect.} = raylib.CloseWindow()

proc end_draw*() {.sideEffect.} = raylib.EndDrawing()

proc get_delta*(): float32 {.sideEffect.} = raylib.GetFrameTime()

proc get_fps*(): int32 {.sideEffect.} = raylib.GetFPS()

proc initialize*(screen_size: Vector2D; title: string) {.sideEffect.} = raylib.InitWindow(
    int32(screen_size.x),
    int32(screen_size.y),
    title,
)

proc is_closing*(): bool {.sideEffect.} = raylib.WindowShouldClose()

proc set_fps*(fps: int32) {.sideEffect.} = raylib.SetTargetFPS(fps)

proc set_window_title*(title: string) {.sideEffect.} = raylib.SetWindowTitle(title)
