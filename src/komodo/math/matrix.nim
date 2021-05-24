from ../private/raylib import nil
from ../private/raymath import nil

import ./vector3


type Matrix* = raylib.Matrix

func transform*(self: Vector3; transformation: Matrix): Vector3 =
  raymath.Vector3Transform(self, transformation)

