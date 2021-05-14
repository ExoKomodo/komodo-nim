import ./math/[
  core,
  matrix,
  quaternion,
  vector2,
  vector3,
  vector4,
  vector_operations,
]

export core
export matrix
export quaternion
export vector2
export vector3
export vector4
export vector_operations

type
  Vector2D* = Vector2 | Vector3 | Vector4
  Vector3D* = Vector3 | Vector4

