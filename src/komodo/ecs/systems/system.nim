{.used.}
import options
import sequtils
import tables

import ../components
import ../entity
import ../ids

type
    System* = ref object of RootObj
        enabled: bool
        entity_to_components: Table[EntityId, seq[Component]]
        initialized: bool
        uninitializedComponents: seq[Component]

func entity_to_components*(self: System): Table[EntityId, seq[Component]] {.inline.} = self.entity_to_components

func `isEnabled=`*(self: System; value: bool) {.inline.} = self.enabled = value
func isEnabled*(self: System): bool {.inline.} = self.enabled

func isInitialized*(self: System): bool {.inline.} = self.initialized

method initialize*(self: System) {.base.} =
    for component in self.uninitializedComponents:
        component.initialize()
    self.uninitializedComponents = @[]
    self.initialized = true

func find_component_by_parent*[T: Component](self: System; parentId: EntityId): Option[T] =
    if not self.entity_to_components.hasKey(parentId):
        return none[T]()
    let components = self.entity_to_components[parentId]
    for component in components:
        if component of T:
            return some[T](T(component))
    return none[T]()

func find_component_by_parent*[T: Component](self: System; parent: Entity): Option[T] =
    self.find_component_by_parent[:T](parent.id)

func register_component*(self: System; component: Component): bool =
    if component.parent.isNone():
        return false
    
    let parent = component.parent.get()
    if not (parent.id in self.entity_to_components):
        self.entity_to_components[parent.id] = @[]
    
    let components = self.entity_to_components[parent.id]
    if components.any(proc (c: Component): bool = return c == component):
        return false

    self.entity_to_components[parent.id] &= component
    return true

method has_necessary_components*(self: System; entity: Entity; components: seq[Component]): bool {.base.} = false

proc refresh_entity_registration*(self: System; entity: Entity) =
    if not self.entity_to_components.hasKey(entity.id):
        return
    let components = self.entity_to_components[entity.id]
    if not self.has_necessary_components(entity, components):
        return
    self.entity_to_components.del(entity.id)

    for component in components:
        discard self.register_component(component)

method draw*(self: System) {.base.} =
    discard

method update*(self: System; delta: float32) {.base.} =
    discard