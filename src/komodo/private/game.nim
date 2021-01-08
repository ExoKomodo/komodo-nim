{.used.}
import options
import tables

import ../ecs/[
    components,
    entity,
    systems,
]
import ../lib/private/raylib


const DefaultScreenSize = Vector2(
    x: 800,
    y: 450,
)
const DefaultTitle = "Komodo Game Engine"

type Game* = object
    clearColor: Option[Color]
    componentStore: Table[ComponentId, Component]
    entityStore: Table[EntityId, Entity]
    isRunning: bool
    screenSize: Option[Vector2]
    systems: seq[System]
    title: Option[string]

func newGame*(): Game =
    result = Game()
    result.systems = @[]

func getCenterOffset(text: cstring; fontSize: int32): int32 =
    MeasureText(text, fontSize) div 2

func drawCenteredText(text: cstring; position: Vector2; fontSize: int32; color: Color) =
    DrawText(
        text,
        int32(position.x) - text.getCenterOffset(fontSize),
        int32(position.y),
        fontSize,
        color,
    )

func draw(self: Game) =
    BeginDrawing()

    for system in self.systems:
        system.draw()
    
    ClearBackground(self.clearColor.get())

    "Hello world".drawCenteredText(
        Vector2(
            x: self.screenSize.get().x / 2,
            y: self.screenSize.get().y / 2,
        ),
        20,
        BLACK,
    )

    EndDrawing()

proc executeOnSystems(self: var Game; predicate: proc (system: System)) =
    for system in self.systems:
        system.predicate()

proc registerComponent*(self: var Game; component: Component): bool =
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

proc registerEntity*(self: var Game; entity: Entity): bool =
    if self.entityStore.hasKey(entity.id):
        return false
    self.entityStore[entity.id] = entity
    self.executeOnSystems(
        proc (system: System) = system.refreshEntityRegistration(entity)
    )
    true

proc registerSystem*(self: var Game; system: System): bool =
    self.systems &= system
    return true

proc initialize(self: var Game) =
    self.isRunning = true
    if self.clearColor.isNone():
        self.clearColor = some(RAYWHITE)
    if self.screenSize.isNone():
        self.screenSize = some(DefaultScreenSize)
    if self.title.isNone():
        self.title = some(DefaultTitle)
    
    for system in self.systems:
        system.initialize()

func update(self: var Game) =
    let delta = GetFrameTime()
    for system in self.systems:
        system.update(delta)

proc run*(self: var Game) =
    if not self.isRunning:
        self.initialize()

        TraceLog(LOG_INFO, "Starting...")
        InitWindow(
            int32(self.screenSize.get().x),
            int32(self.screenSize.get().y),
            self.title.get(),
        )
        SetTargetFPS(60)

        while not WindowShouldClose():
            self.update()
            self.draw()

func setClearColor*(self: var Game; clearColor: Color) =
    self.clearColor = some(clearColor)

func setScreenSize*(self: var Game; screenSize: Vector2) =
    if not self.isRunning:
        self.screenSize = some(screenSize)

func setTitle*(self: var Game; title: string) =
    if not self.isRunning:
        self.title = some(title)

func quit*(self: var Game) =
    if self.isRunning:
        self.isRunning = false
        CloseWindow()
