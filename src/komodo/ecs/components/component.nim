{.used.}
import options
import ../entity
import ../ids

type
    Component* = ref object of RootObj
        id*: ComponentId
        isEnabled: bool
        isInitialized: bool
        parent: Option[Entity]

func `isEnabled=`*(self: Component; value: bool) {.inline.} = self.isEnabled = value
func isEnabled*(self: Component): bool {.inline.} = self.isEnabled

func isInitialized*(self: Component): bool {.inline.} = self.isInitialized

func `parent=`*(self: Component; value: Entity) = self.parent = some(value)
func parent*(self: Component): Option[Entity] = self.parent

method initialize*(self: Component) {.base.} =
    if not self.isInitialized:
        self.isInitialized = true
