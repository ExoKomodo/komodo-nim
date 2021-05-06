from ../utils/private/raylib import nil


type MouseButtons* {.pure.} = enum
  Left = 0
  Right = 1
  Middle = 2

converter MouseButtonToint32*(self: MouseButtons): int32 = self.int32
converter Int32ToMouseButtons*(self: int32): MouseButtons = self.MouseButtons

func isDown*(self: MouseButtons): bool =
  result = raylib.IsMouseButtonDown(self)

func isUp*(self: MouseButtons): bool =
  result = raylib.IsMouseButtonUp(self)

func isPressed*(self: MouseButtons): bool =
  result = raylib.IsMouseButtonPressed(self)

func isReleased*(self: MouseButtons): bool =
  result = raylib.IsMouseButtonReleased(self)

