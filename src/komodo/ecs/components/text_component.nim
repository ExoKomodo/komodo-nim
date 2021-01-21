import komodo/ecs/components/component
import komodo/ecs/entity
import komodo/ecs/ids
import komodo/lib/raylib

type
    TextComponent* = ref object of Component
        text: string
        fontSize: int32
        color: Color

proc newTextComponent*(
    parent: Entity;
    text: string;
    fontSize: int32 = 20;
    color: Color = BLACK;
    isEnabled: bool = true;
): TextComponent =
    result = TextComponent(
        id: nextComponentId(),
        text: text,
        fontSize: fontSize,
        color: color,
    )
    result.parent = parent
    result.isEnabled = isEnabled

func text*(self: TextComponent): auto = self.text
func `text=`*(self: TextComponent; value: string) = self.text = value

func fontSize*(self: TextComponent): auto = self.fontSize
func `fontSize=`*(self: TextComponent; value: int32) = self.fontSize = value

func color*(self: TextComponent): auto = self.color
func `color=`*(self: TextComponent; value: Color) = self.color = value

const TextComponentTypeId* = "TextComponent"

method initialize*(self: TextComponent) =
    procCall self.Component.initialize()

method typeId*(self: TextComponent): string = TextComponentTypeId
