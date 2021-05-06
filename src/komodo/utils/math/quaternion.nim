from ../private/raylib import nil
from ../private/raymath import nil

import ./vector3


type Quaternion* = raylib.Quaternion

func rotate*(self: Vector3; rotation: Quaternion): Vector3 =
  raymath.Vector3RotateByQuaternion(self, rotation)

