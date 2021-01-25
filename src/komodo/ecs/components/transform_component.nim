import ./component
import ../entity
import ../ids

from ../../lib/raylib import Vector3

type
    TransformComponent* = ref object of Component
        position: Vector3
        rotation: Vector3
        scale: Vector3

proc newTransformComponent*(
    parent: Entity;
    position: Vector3;
    rotation: Vector3;
    scale: Vector3;
    isEnabled: bool = true;
): TransformComponent =
    result = TransformComponent(
        id: nextComponentId(),
        position: position,
        rotation: rotation,
        scale: scale,
    )
    result.parent = parent
    result.isEnabled = isEnabled

func position*(self: TransformComponent): auto = self.position
func `position=`*(self: TransformComponent; value: Vector3) = self.position = value

func rotation*(self: TransformComponent): auto = self.rotation
func `rotation=`*(self: TransformComponent; value: Vector3) = self.rotation = value

func scale*(self: TransformComponent): auto = self.scale
func `scale=`*(self: TransformComponent; value: Vector3) = self.scale = value

const TransformComponentTypeId* = "TransformComponent"

method initialize*(self: TransformComponent) =
    procCall self.Component.initialize()

method typeId*(self: TransformComponent): auto = TransformComponentTypeId
