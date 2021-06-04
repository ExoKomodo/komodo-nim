import options
import strformat
import strutils
import tables

import ../drawable
import ../../resource_config

from ../../private/raylib import nil
from ../../logging import nil


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

func constructResourcePath(config: ResourceConfig, path: string): string =
  fmt"{config.directory}/{path}"

proc load_font*(
  self: ResourceCache;
  drawable: Drawable;
  config: ResourceConfig;
): Option[FontResource] =
  case drawable.kind:
    of DrawableKind.text:
      if drawable.font_path.isEmptyOrWhitespace:
        none[FontResource]()
      elif drawable.font_path notin self.font_cache:
        let font = raylib.LoadFont(constructResourcePath(config, drawable.font_path))
        self.font_cache[drawable.font_path] = font
        some(font)
      else:
        some(self.font_cache[drawable.font_path])
    else:
      none[FontResource]()

proc load_texture*(
  self: ResourceCache;
  drawable: Drawable;
  config: ResourceConfig;
): Option[TextureResource] =
  case drawable.kind:
    of DrawableKind.image:
      if drawable.image_path notin self.texture_cache:
        let image = raylib.LoadImage(constructResourcePath(config, drawable.image_path))
        let texture = raylib.LoadTextureFromImage(image)
        raylib.UnloadImage(image)
        self.texture_cache[drawable.image_path] = texture
        some(texture)
      else:
        some(self.texture_cache[drawable.image_path])
    else:
      none[TextureResource]()

proc load*(
  self: ResourceCache;
  drawable: Drawable;
  config: ResourceConfig;
): Option[Resource] =
  case drawable.kind:
    of DrawableKind.image:
      let texture = self.load_texture(drawable, config)
      if texture.is_none:
        none[Resource]()
      else:
        some(texture)
    of DrawableKind.text:
      let font = self.load_font(drawable, config)
      if font.is_none:
        none[Resource]()
      else:
        some(font)
    else:
      none[Resource]()

proc unload(
  self: ResourceCache;
  font: raylib.Font;
  config: ResourceConfig;
) =
  raylib.UnloadFont(font)

proc unload(
  self: ResourceCache;
  texture: raylib.Texture;
  config: ResourceConfig;
) =
  raylib.UnloadTexture(texture)

proc unload*(
  self: ResourceCache;
  drawable: Drawable;
  config: ResourceConfig;
) =
  case drawable.kind:
    of DrawableKind.image:
      let texture = self.load_texture(drawable, config)
      if texture.is_some:
        self.unload(texture.unsafe_get, config)
    of DrawableKind.text:
      let font = self.load_font(drawable, config)
      if font.is_some:
        self.unload(font.unsafe_get, config)
    else:
      discard

proc unload*(
  self: ResourceCache;
  config: ResourceConfig;
) =
  for path, font_asset in self.font_cache.pairs:
    logging.log_info(fmt"Unloading font: {path}")
    self.unload(font_asset, config)
    logging.log_info(fmt"Unloaded font: {path}")
  
  for path, texture_asset in self.texture_cache.pairs:
    logging.log_info(fmt"Unloading texture: {path}")
    self.unload(texture_asset, config)
    logging.log_info(fmt"Unloaded texture: {path}")

