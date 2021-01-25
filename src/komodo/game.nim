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
    clear_color: Option[Color]
    component_store: Table[ComponentId, Component]
    entity_store: Table[EntityId, Entity]
    is_running: bool
    screen_size: Option[Vector2]
    systems: seq[System]
    title: string

func clear_color*(self: Game): Color {.inline.} =
    if self.clear_color.isNone():
        return DefaultClearColor
    return self.clear_color.get()
func `clear_color=`*(self: Game; value: Color) {.inline.} = self.clear_color = some(value)

func is_running*(self: Game): bool {.inline.} = self.is_running

func title*(self: Game): string {.inline.} = self.title
func `title=`*(self: Game; value: string) {.inline.} =
    if self.is_running:
        SetWindowTitle(value)
    self.title = value

func screen_size*(self: Game): Vector2 {.inline.} =
    if self.screen_size.isNone():
        return DefaultScreenSize
    return self.screen_size.get()

func new_game*(): Game =
    result = Game()
    result.systems = @[]
    InitWindow(
        int32(screen_size(result).x),
        int32(screen_size(result).y),
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

proc register_component*(self: Game; component: Component): bool =
    if self.component_store.hasKey(component.id):
        return false
    if component.parent.isNone:
        return false
    let parent = component.parent.get()
    self.component_store[component.id] = component

    self.executeOnSystems(
        proc (system: System) =
            if system.register_component(component):
                system.refresh_entity_registration(parent)
    )
    true

proc register_entity*(self: Game; entity: Entity): bool =
    if self.entity_store.hasKey(entity.id):
        return false
    self.entity_store[entity.id] = entity
    self.executeOnSystems(
        proc (system: System) = system.refresh_entity_registration(entity)
    )
    true

proc register_system*(self: Game; system: System): bool =
    self.systems &= system
    return true

proc initialize(self: Game) =
    self.is_running = true
    if self.clearColor.isNone():
        self.clearColor = some(DefaultClearColor)
    if self.screen_size.isNone():
        self.screen_size = some(Defaultscreen_size)
    if self.title == "":
        self.title = DefaultTitle
    
    for system in self.systems:
        system.initialize()

func update(self: Game) =
    let delta = GetFrameTime()
    for system in self.systems:
        system.update(delta)

proc run*(self: Game) =
    if not self.is_running:
        self.initialize()

        TraceLog(LOG_INFO, "Starting...")
        SetTargetFPS(60)

        while not WindowShouldClose():
            self.update()
            self.draw()

func setClearColor*(self: Game; clearColor: Color) =
    self.clearColor = some(clearColor)

func quit*(self: Game) =
    if self.is_running:
        self.is_running = false
        CloseWindow()
