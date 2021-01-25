{.used.}
import options
import ../entity
import ../ids

type
    Component* = ref object of RootObj
        id*: ComponentId
        is_enabled: bool
        is_initialized: bool
        parent: Option[Entity]

func `is_enabled=`*(self: Component; value: bool) {.inline.} = self.is_enabled = value
func is_enabled*(self: Component): bool {.inline.} = self.is_enabled

func is_initialized*(self: Component): bool {.inline.} = self.is_initialized

func `parent=`*(self: Component; value: Entity) {.inline.} = self.parent = some(value)
func parent*(self: Component): Option[Entity] {.inline.} = self.parent

method initialize*(self: Component) {.base.} =
    if not self.is_initialized:
        self.is_initialized = true
