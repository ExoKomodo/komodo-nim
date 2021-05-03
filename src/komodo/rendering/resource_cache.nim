import options
import tables

import ./drawable

from ../utils/private/raylib import nil


type
  FontResource* = raylib.Font
  TextureResource* = raylib.Texture
  Resource* = FontResource or TextureResource
  ResourceCache* = ref object
    font_cache: TableRef[string, raylib.Font]
    texture_cache: TableRef[string, raylib.Texture]

func newResourceCache*(): ResourceCache =
  ResourceCache(
    font_cache: newTable[string, raylib.Font](),
    texture_cache: newTable[string, raylib.Texture](),
  )

proc load_font*(self: ResourceCache; drawable: Drawable): Option[FontResource] =
  case drawable.kind:
    of DrawableKind.image:
      none[FontResource]()
    of DrawableKind.text:
      if drawable.font_path notin self.font_cache:
        let font = raylib.LoadFont(drawable.font_path)
        self.font_cache[drawable.font_path] = font
        some(font)
      else:
        some(self.font_cache[drawable.font_path])

proc load_texture*(self: ResourceCache; drawable: Drawable): Option[TextureResource] =
  case drawable.kind:
    of DrawableKind.image:
      if drawable.image_path notin self.texture_cache:
        let image = raylib.LoadImage(drawable.image_path)
        let texture = raylib.LoadTextureFromImage(image)
        raylib.UnloadImage(image)
        self.texture_cache[drawable.image_path] = texture
        some(texture)
      else:
        some(self.texture_cache[drawable.image_path])
    of DrawableKind.text:
      none[TextureResource]()

proc load*(self: ResourceCache; drawable: Drawable): Option[Resource] =
  case drawable.kind:
    of DrawableKind.image:
      let texture = self.load_texture(drawable)
      if texture.is_none:
        none[Resource]()
      else:
        some(texture)
    of DrawableKind.text:
      let font = self.load_font(drawable)
      if font.is_none:
        none[Resource]()
      else:
        some(font)
