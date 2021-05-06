from ../private/raylib import nil
from ../private/raymath import nil

from math import `^`, sqrt



type Vector2* = raylib.Vector2

const
  DOWN* = Vector2(
    x: 0,
    y: 1,
  )
  UP* = Vector2(
    x: 0,
    y: -1,
  )

  RIGHT* = Vector2(
    x: 1,
    y: 0,
  )
  LEFT* = Vector2(
    x: -1,
    y: 0,
  )
  
  ONE* = raymath.Vector2One
  ZERO* = raymath.Vector2Zero

func `*`*(a: Vector2; b: Vector2): Vector2 =
  raymath.Vector2Multiply(a, b)

func `*`*(self: Vector2; scale: float32): Vector2 =
  raymath.Vector2Scale(self, scale)

func `*`*(scale: float32; self: Vector2): Vector2 =
  raymath.Vector2Scale(self, scale)

func `+`*(a: Vector2; b: Vector2): Vector2 =
  raymath.Vector2Add(a, b)

func `-`*(a: Vector2; b: Vector2): Vector2 =
  raymath.Vector2Subtract(a, b)

func `-`*(self: Vector2): Vector2 =
  raymath.Vector2Negate(self)

func angle*(a: Vector2; b: Vector2): float32 =
  raymath.Vector2Angle(a, b)

func distance*(a: Vector2; b: Vector2): float32 =
  raymath.Vector2Distance(a, b)

func divide*(a: Vector2; b: Vector2): Vector2 =
  raymath.Vector2Divide(a, b)

func dot*(a: Vector2; b: Vector2): float32 =
  raymath.Vector2DotProduct(a, b)

func lengthSquared*(self: Vector2): float32 =
  self.x^2 + self.y^2

func length*(self: Vector2): float32 =
  self.lengthSquared.sqrt()

func lerp*(a: Vector2; b: Vector2; amount: float32): Vector2 =
  raymath.Vector2Lerp(a, b, amount)

func max*(a: Vector2; b: Vector2): Vector2 =
  Vector2(
    x: max(a.x, b.x),
    y: max(a.y, b.y),
  )

func min*(a: Vector2; b: Vector2): Vector2 =
  Vector2(
    x: min(a.x, b.x),
    y: min(a.y, b.y),
  )

func moveTowards*(self: Vector2; target: Vector2; max_distance: float32): Vector2 =
  raymath.Vector2MoveTowards(self, target, max_distance)

func normalize*(self: Vector2): Vector2 =
  raymath.Vector2Normalize(self)

func reflect*(self: Vector2; normal: Vector2): Vector2 =
  raymath.Vector2Reflect(self, normal)

func rotate*(self: Vector2; degrees: float32): Vector2 =
  raymath.Vector2Rotate(self, degrees)

