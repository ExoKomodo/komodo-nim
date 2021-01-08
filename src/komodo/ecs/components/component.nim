{.used.}
import options
import ../entity

type
    ComponentId* = int
    Component* = ref object of RootObj
        id*: ComponentId
        enabled: bool
        initialized: bool
        parentEntity: Option[Entity]

const ComponentTypeId = "Component"

proc nextComponentId*(): ComponentId {.inline.} =
    var nextId {.global.}: ComponentId = 0
    nextId.inc()
    nextId

func `isEnabled=`*(self: Component; value: bool) {.inline.} = self.enabled = value
func isEnabled*(self: Component): bool {.inline.} = self.enabled

func isInitialized*(self: Component): bool {.inline.} = self.initialized

func `parent=`*(self: Component; value: Entity) {.inline.} = self.parentEntity = some(value)
func parent*(self: Component): Option[Entity] {.inline.} = self.parentEntity

method initialize*(self: Component) {.base.} =
    if not self.isInitialized:
        self.initialized = true

method typeId*(self: Component): string {.base.} = ComponentTypeId