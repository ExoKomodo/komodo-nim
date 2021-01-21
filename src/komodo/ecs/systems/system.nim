{.used.}
import options
import sequtils
import sets
import tables

import komodo/ecs/components
import komodo/ecs/entity

type
    System* = ref object of RootObj
        enabled: bool
        entityToComponents: Table[EntityId, seq[Component]]
        initialized: bool
        registeredTypes*: HashSet[string]
        uninitializedComponents: seq[Component]

func entityToComponents*(self: System): Table[EntityId, seq[Component]] {.inline.} = self.entityToComponents

func `isEnabled=`*(self: System; value: bool) {.inline.} = self.enabled = value
func isEnabled*(self: System): bool {.inline.} = self.enabled

func isInitialized*(self: System): bool {.inline.} = self.initialized

method initialize*(self: System) {.base.} =
    for component in self.uninitializedComponents:
        component.initialize()
    self.uninitializedComponents = @[]
    self.initialized = true

func findComponentByParent*[T: Component](self: System; parentId: EntityId; registeredType: string): Option[T] =
    if not self.entityToComponents.hasKey(parentId):
        return none[T]()
    let components = self.entityToComponents[parentId]
    for component in components:
        if component.typeId() == registeredType:
            return some[T](T(component))
    return none[T]()

func findComponentByParent*[T: Component](self: System; parent: Entity; registeredType: string): Option[T] =
    self.findComponentByParent[:T](parent.id, registeredType)

func registerComponent*(self: System; component: Component): bool =
    if not (component.typeId() in self.registeredTypes):
        return false
    if component.parent.isNone():
        return false
    
    let parent = component.parent.get()
    if not (parent.id in self.entityToComponents):
        self.entityToComponents[parent.id] = @[]
    
    let components = self.entityToComponents[parent.id]
    if components.any(proc (c: Component): bool = return c == component):
        return false

    self.entityToComponents[parent.id] &= component
    return true

func refreshEntityRegistration*(self: System; entity: Entity) =
    if not self.entityToComponents.hasKey(entity.id):
        return
    let components = self.entityToComponents[entity.id]
    var missingType = false
    for registeredType in self.registeredTypes:
        let foundComponent = self.findComponentByParent[:Component](entity, registeredType)
        if foundComponent.isNone():
            missingType = true
    if missingType:
        return
    self.entityToComponents.del(entity.id)

    for component in components:
        discard self.registerComponent(component)

method draw*(self: System) {.base.} =
    discard

method update*(self: System; delta: float32) {.base.} =
    discard