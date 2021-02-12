import options
import sequtils
import tables

from sugar import `=>`

import ./ecs/[
    components,
    entity,
    ids,
    systems,
]
import ./lib/graphics
import ./lib/math
import ./logging


const DefaultScreenSize = Vector2(
    x: 800,
    y: 600,
)
const DefaultTitle = "Komodo Game Engine"
const DefaultClearColor = White
const DefaultCamera = Camera(
  position: Vector3(x: 0, y: 10, z: 10),
  target: Vector3(x: 0, y: 0, z: 0),
  up: Vector3(x: 0, y: 1, z: 0),
  fovy: 45,
  typex: 0,
)

type Game* = ref object
  camera: Option[Camera]
  clearColor: Option[Color]
  componentStore: Table[ComponentId, Component]
  entityStore: Table[EntityId, Entity]
  isRunning: bool
  screenSize: Option[Vector2]
  systems: seq[System]
  title: string

var instance* {.global.} = none[Game]()

func camera*(self: Game): auto {.inline.} =
  if self.camera.isNone():
    DefaultCamera
  else:
    self.camera.unsafeGet()

func clearColor*(self: Game): auto {.inline.} =
  if self.clearColor.isNone():
    DefaultClearColor
  else:
    self.clearColor.unsafeGet()
func `clearColor=`*(self: Game; value: Color) {.inline.}
    = self.clearColor = some(value)

func isRunning*(self: Game): auto {.inline.} = self.isRunning

func title*(self: Game): auto {.inline.} = self.title
func `title=`*(self: Game; value: string) {.inline.} =
  if self.isRunning:
    setWindowTitle(value)
  self.title = value

func screenSize*(self: Game): auto {.inline.} =
  if self.screenSize.isNone():
    return DefaultScreenSize
  return self.screenSize.get()

proc newGame*(): Game =
  result = Game()
  result.systems = @[]
  initWindow(
      screenSize(result),
      result.title,
  )
  instance = some(result)

func draw(self: Game) =
  beginDraw()

  self.clearColor.clearScreen()

  let camera = camera(self)
  for system in self.systems:
    system.draw(camera)
  endDraw()

proc executeOnSystems*(self: Game; predicate: proc (system: System)) =
  for system in self.systems:
    system.predicate()

proc deregisterComponent*(self: Game; component: Component): bool =
  if not self.componentStore.hasKey(component.id):
    return false
  if component.parent.isNone:
    return false

  let parent = component.parent.get()
  self.executeOnSystems(proc (system: System) =
    if system.deregisterComponent(component):
      system.refreshEntityRegistration(parent)
  )
  self.componentStore.del(component.id)
  true

proc deregisterEntity*(self: Game; entity: Entity): bool =
  if not self.entityStore.hasKey(entity.id):
    return false
  self.executeOnSystems(proc (system: System) =
    if system.deregisterEntity(entity):
      system.refreshEntityRegistration(entity)
  )
  self.entityStore.del(entity.id)
  true

proc deregisterSystem*(self: Game; system: System): bool =
  if not (system in self.systems):
    return false
  self.systems.keepIf(_ => _ != system)
  true

proc registerComponent*(self: Game; component: Component): bool =
  if self.componentStore.hasKey(component.id):
    return false
  if component.parent.isNone:
    return false
  let parent = component.parent.get()
  self.componentStore[component.id] = component

  self.executeOnSystems(proc (system: System) =
    if system.registerComponent(component):
      system.refreshEntityRegistration(parent)
  )
  true

proc registerEntity*(self: Game; entity: Entity): bool =
  if self.entityStore.hasKey(entity.id):
    return false
  self.entityStore[entity.id] = entity
  self.executeOnSystems(proc (system: System) =
    system.refreshEntityRegistration(entity)
  )
  true

proc registerSystem*(self: Game; system: System): bool =
  self.systems &= system
  return true

proc initialize(self: Game) =
  self.isRunning = true
  if self.camera.isNone():
    self.camera = some(DefaultCamera)
  if self.clearColor.isNone():
    self.clearColor = some(DefaultClearColor)
  if self.screenSize.isNone():
    self.screenSize = some(DefaultscreenSize)
  if self.title == "":
    self.title = DefaultTitle

  for system in self.systems:
    system.initialize()

func update(self: Game) =
  let delta = getDelta()
  for system in self.systems:
    system.update(delta)

proc run*(self: Game) =
  if not self.isRunning:
    logInfo("Starting...")
    setFps(60)

    while not isClosing():
      self.initialize()
      self.update()
      self.draw()

func setClearColor*(self: Game; clearColor: Color) =
  self.clearColor = some(clearColor)

func quit*(self: Game) =
  if self.isRunning:
    self.isRunning = false
    close()
