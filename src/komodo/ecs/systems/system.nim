{.used.}
import options
import sequtils
import tables

from sugar import `=>`

import ../components
import ../entity
import ../ids
import ../../lib/graphics/camera


type
  SystemObj = object of RootObj
    entityToComponents: Table[EntityId, seq[Component]]
    initialized: bool
    uninitializedComponents: seq[Component]

  System* = ref SystemObj

func destroy*(self: var SystemObj) =
  self.entityToComponents.clear()
  self.uninitializedComponents = @[]

func entityToComponents*(self: System): Table[EntityId, seq[Component]] {.inline.}
    = self.entityToComponents

func isInitialized*(self: SystemObj | System): bool {.inline.}
    = self.initialized

method initialize*(self: System) {.base.} =
  for component in self.uninitializedComponents:
    if (
      component.isInitialized or
      component.parent.isNone() or
      not (component.parent.unsafeGet().id in self.entityToComponents)
    ):
      continue
    component.initialize()
  self.uninitializedComponents = @[]
  self.initialized = true

func findComponentByParent*[T: Component](
    self: System;
    parentId: EntityId;
): Option[T] =
  if not self.entityToComponents.hasKey(parentId):
    return none[T]()
  let components = self.entityToComponents[parentId]
  for component in components:
    if component of T:
      return some[T](T(component))
  return none[T]()

func findComponentByParent*[T: Component](self: System; parent: Entity): Option[T] =
  self.findComponentByParent[:T](parent.id)

proc deregisterComponent*(self: System; component: Component): bool =
  if component.parent.isNone():
    return false

  let parent = component.parent.get()
  if not (parent.id in self.entityToComponents):
    return false

  var components = self.entityToComponents[parent.id]
  components.keepIf(_ => _ != component)
  return true

proc deregisterEntity*(self: System; entity: Entity): bool =
  if not (entity.id in self.entityToComponents):
    return false
  self.entityToComponents.del(entity.id)
  true

func registerComponent*(self: System; component: Component): bool =
  if component.parent.isNone():
    return false

  let parent = component.parent.get()
  if not (parent.id in self.entityToComponents):
    self.entityToComponents[parent.id] = @[]

  let components = self.entityToComponents[parent.id]
  if components.any(_ => _ == component):
    return false

  self.entityToComponents[parent.id] &= component
  if not component.isInitialized:
    self.uninitializedComponents &= component
  return true

method hasNecessaryComponents*(
    self: System;
    entity: Entity;
    components: seq[Component];
): bool {.base.} = false

proc refreshEntityRegistration*(self: System; entity: Entity) =
  if not self.entityToComponents.hasKey(entity.id):
    return
  let components = self.entityToComponents[entity.id]
  if not self.hasNecessaryComponents(entity, components):
    return
  self.entityToComponents.del(entity.id)

  for component in components:
    discard self.registerComponent(component)

method draw*(self: System; injected_camera: Camera) {.base.} =
  discard

method update*(self: System; delta: float32) {.base.} =
  discard
