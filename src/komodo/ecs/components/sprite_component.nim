import ../../lib/raylib

import ./component_macros

component SpriteComponent:
    fields:
        color: Color
        texture: Texture2D
    
    create(
        texturePath: string,
        color: Color,
    ):
        let image = LoadImage(texturePath)
        result.color = color
        result.texture = LoadTextureFromImage(image)
        image.UnloadImage()

    init:
        discard

    final:
        self.texture.UnloadTexture()

func `color=`*(self: SpriteComponent; value: Color): auto = self.color = value
func color*(self: SpriteComponent): auto = self.color

func texture*(self: SpriteComponent): auto = self.texture
