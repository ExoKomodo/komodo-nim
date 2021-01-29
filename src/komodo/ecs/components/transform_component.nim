import ../../lib/math

import ./component_macros


component TransformComponent:
    fields:
        position: Vector3
        rotation: Vector3
        scale: Vector3
    
    create(
        position: Vector3,
        rotation: Vector3,
        scale: Vector3,
    ):
        result.position = position
        result.rotation = rotation
        result.scale = scale

    init:
        discard

    destroy:
        discard

func position*(self: TransformComponent): auto = self.position
func `position=`*(self: TransformComponent; value: Vector3) = self.position = value

func rotation*(self: TransformComponent): auto = self.rotation
func `rotation=`*(self: TransformComponent; value: Vector3) = self.rotation = value

func scale*(self: TransformComponent): auto = self.scale
func `scale=`*(self: TransformComponent; value: Vector3) = self.scale = value
