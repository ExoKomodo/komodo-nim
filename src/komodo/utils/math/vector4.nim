from ../private/raylib import nil

type Vector4* = raylib.Vector4

func `*`*(self: Vector4; scale: float32): Vector4 =
  Vector4(
    x: self.x * scale,
    y: self.y * scale,
    z: self.z * scale,
    w: self.w * scale,
  )

func `*`*(scale: float32; self: Vector4): Vector4 =
  Vector4(
    x: self.x * scale,
    y: self.y * scale,
    z: self.z * scale,
    w: self.w * scale,
  )

func `+`*(a: Vector4; b: Vector4): Vector4 =
  Vector4(
    x: a.x + b.x,
    y: a.y + b.y,
    z: a.z + b.z,
    w: a.w + b.w,
  )

func `-`*(a: Vector4; b: Vector4): Vector4 =
  Vector4(
    x: a.x - b.x,
    y: a.y - b.y,
    z: a.z - b.z,
    w: a.w + b.w,
  )

func `-`*(self: Vector4): Vector4 =
  self * -1

func dot*(a: Vector4, b: Vector4): Vector4 =
  Vector4(
    x: a.x * b.x,
    y: a.y * b.y,
    z: a.z * b.z,
    w: a.w * b.w,
  )

