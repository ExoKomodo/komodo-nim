import ./component
import ../entity
import ../ids
import ../../lib/raylib

type
    SpriteComponent* = ref object of Component
        color: Color
        texture: Texture2D

func `color=`*(self: SpriteComponent; value: Color): auto = self.color = value
func color*(self: SpriteComponent): auto = self.color

func texture*(self: SpriteComponent): auto = self.texture

proc new_sprite_component*(
    parent: Entity;
    texture_path: string;
    color: Color = WHITE;
    is_enabled: bool = true;
): SpriteComponent =
    let image = LoadImage(texture_path)
    result = SpriteComponent(
        id: nextComponentId(),
        color: color,
        texture: LoadTextureFromImage(image),
    )
    image.UnloadImage()
    result.parent = parent
    result.is_enabled = is_enabled

proc finalizer*(self: SpriteComponent) =
  self.texture.UnloadTexture()

method initialize*(self: SpriteComponent) =
    procCall self.Component.initialize()
