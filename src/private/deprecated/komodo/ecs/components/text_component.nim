import ../../lib/graphics/color

import ./component_macros

component TextComponent:
  fields:
    text: string
    fontSize: int32
    color: Color

  create(
      text: string,
      fontSize: int32,
      color: Color,
  ):
    result.text = text
    result.fontSize = fontSize
    result.color = color

  init:
    discard

  destroy:
    discard

func text*(self: TextComponent): auto = self.text
func `text=`*(self: TextComponent; value: string) = self.text = value

func fontSize*(self: TextComponent): auto = self.fontSize
func `fontSize=`*(self: TextComponent; value: int32) = self.fontSize = value

func color*(self: TextComponent): auto = self.color
func `color=`*(self: TextComponent; value: Color) = self.color = value
