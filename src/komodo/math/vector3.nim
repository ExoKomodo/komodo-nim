from ../private/raylib import nil
from ../private/raymath import nil

from math import `^`, sqrt


type Vector3* = raylib.Vector3

const
  DOWN* = Vector3(
    x: 0,
    y: 1,
    z: 0,
  )
  UP* = Vector3(
    x: 0,
    y: -1,
    z: 0,
  )

  LEFT* = Vector3(
    x: -1,
    y: 0,
    z: 0,
  )
  RIGHT* = Vector3(
    x: 1,
    y: 0,
    z: 0,
  )
  
  ONE* = raymath.Vector3One
  ZERO* = raymath.Vector3Zero

func `*`*(a: Vector3; b: Vector3): Vector3 =
  raymath.Vector3Multiply(a, b)

func `*`*(self: Vector3; scale: float32): Vector3 =
  raymath.Vector3Scale(self, scale)

func `*`*(scale: float32; self: Vector3): Vector3 =
  raymath.Vector3Scale(self, scale)

func `+`*(a: Vector3; b: Vector3): Vector3 =
  raymath.Vector3Add(a, b)

func `+`*(a: Vector3; b: float32): Vector3 =
  raymath.Vector3AddValue(a, b)

func `-`*(a: Vector3; b: Vector3): Vector3 =
  raymath.Vector3Subtract(a, b)

func `-`*(a: Vector3; b: float32): Vector3 =
  raymath.Vector3SubtractValue(a, b)

func `-`*(self: Vector3): Vector3 =
  raymath.Vector3Negate(self)

func barycenter*(point: Vector3; a: Vector3; b: Vector3; c: Vector3): Vector3 =
  raymath.Vector3Barycenter(point, a, b, c)

func cross*(a: Vector3; b: Vector3): Vector3 =
  raymath.Vector3CrossProduct(a, b)

func distance*(a: Vector3; b: Vector3): float32 =
  raymath.Vector3Distance(a, b)

func divide*(a: Vector3; b: Vector3): Vector3 =
  raymath.Vector3Divide(a, b)

func dot*(a: Vector3; b: Vector3): float32 =
  raymath.Vector3DotProduct(a, b)

func lengthSquared*(self: Vector3): float32 =
  self.x^2 + self.y^2 + self.z^2

func length*(self: Vector3): float32 =
  self.lengthSquared.sqrt()

func lerp*(a: Vector3; b: Vector3; amount: float32): Vector3 =
  raymath.Vector3Lerp(a, b, amount)

func max*(a: Vector3; b: Vector3): Vector3 =
  raymath.Vector3Max(a, b)

func min*(a: Vector3; b: Vector3): Vector3 =
  raymath.Vector3Min(a, b)

func normalize*(self: Vector3): Vector3 =
  raymath.Vector3Normalize(self)

func perpendicular*(self: Vector3): Vector3 =
  raymath.Vector3Perpendicular(self)

func reflect*(self: Vector3; normal: Vector3): Vector3 =
  raymath.Vector3Reflect(self, normal)

