{.used.}
import options
import tables

import ./ecs/[
    components,
    entity,
    ids,
    systems,
]
import ./lib/raylib


const DefaultScreenSize = Vector2(
    x: 800,
    y: 600,
)
const DefaultTitle = "Komodo Game Engine"
const DefaultClearColor = RAYWHITE

type Game* = ref object
    clearColor: Option[Color]
    componentStore: Table[ComponentId, Component]
    entityStore: Table[EntityId, Entity]
    isRunning: bool
    screenSize: Option[Vector2]
    systems: seq[System]
    title: string

func clearColor*(self: Game): Color {.inline.} =
    if self.clearColor.isNone():
        return DefaultClearColor
    return self.clearColor.get()
func `clearColor=`*(self: Game; value: Color) {.inline.} = self.clearColor = some(value)

func isRunning*(self: Game): bool {.inline.} = self.isRunning

func title*(self: Game): string {.inline.} = self.title
func `title=`*(self: Game; value: string) {.inline.} =
    if self.isRunning:
        SetWindowTitle(value)
    self.title = value

func screenSize*(self: Game): Vector2 {.inline.} =
    if self.screenSize.isNone():
        return DefaultScreenSize
    return self.screenSize.get()

func newGame*(): Game =
    result = Game()
    result.systems = @[]
    InitWindow(
        int32(screenSize(result).x),
        int32(screenSize(result).y),
        result.title,
    )

func draw(self: Game) =
    BeginDrawing()

    for system in self.systems:
        system.draw()
    
    ClearBackground(self.clearColor.get())

    EndDrawing()

proc executeOnSystems(self: Game; predicate: proc (system: System)) =
    for system in self.systems:
        system.predicate()

proc registerComponent*(self: Game; component: Component): bool =
    if self.componentStore.hasKey(component.id):
        return false
    if component.parent.isNone:
        return false
    let parent = component.parent.get()
    self.componentStore[component.id] = component

    self.executeOnSystems(
        proc (system: System) =
            if system.registerComponent(component):
                system.refreshEntityRegistration(parent)
    )
    true

proc registerEntity*(self: Game; entity: Entity): bool =
    if self.entityStore.hasKey(entity.id):
        return false
    self.entityStore[entity.id] = entity
    self.executeOnSystems(
        proc (system: System) = system.refreshEntityRegistration(entity)
    )
    true

proc registerSystem*(self: Game; system: System): bool =
    self.systems &= system
    return true

proc initialize(self: Game) =
    self.isRunning = true
    if self.clearColor.isNone():
        self.clearColor = some(DefaultClearColor)
    if self.screenSize.isNone():
        self.screenSize = some(DefaultscreenSize)
    if self.title == "":
        self.title = DefaultTitle
    
    for system in self.systems:
        system.initialize()

func update(self: Game) =
    let delta = GetFrameTime()
    for system in self.systems:
        system.update(delta)

proc run*(self: Game) =
    if not self.isRunning:
        self.initialize()

        TraceLog(LOG_INFO, "Starting...")
        SetTargetFPS(60)

        while not WindowShouldClose():
            self.update()
            self.draw()

func setClearColor*(self: Game; clearColor: Color) =
    self.clearColor = some(clearColor)

func quit*(self: Game) =
    if self.isRunning:
        self.isRunning = false
        CloseWindow()
