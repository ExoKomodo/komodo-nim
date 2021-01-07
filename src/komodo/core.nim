import lib/private/raylib
import options

func getWelcomeMessage*(): string =
    "Hello, World!"

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

const DefaultScreenSize = Vector2(
    x: 800,
    y: 450,
)
const DefaultTitle = "Komodo Game Engine"

import ecs/components/behavior_component
type Game* = object
    isRunning: bool
    screenSize: Option[Vector2]
    clearColor: Option[Color]
    title: Option[string]
    testBehavior: BehaviorComponent

type
    TestBehavior = ref object of BehaviorComponent

func newTestBehavior(isEnabled: bool = true): TestBehavior =
    result = TestBehavior()
    result.isEnabled = isEnabled

func newGame*(): Game =
    result = Game()
    result.testBehavior = newTestBehavior()

func draw(game: Game) =
    BeginDrawing()
    
    ClearBackground(game.clearColor.get())

    "Hello world".drawCenteredText(
        Vector2(
            x: game.screenSize.get().x / 2,
            y: game.screenSize.get().y / 2,
        ),
        20,
        BLACK,
    )

    EndDrawing()

method update(self: TestBehavior; delta: float32) =
    TraceLog(LOG_INFO, "Test")

func initialize(game: var Game) =
    game.isRunning = true
    if game.clearColor.isNone():
        game.clearColor = some(RAYWHITE)
    if game.screenSize.isNone():
        game.screenSize = some(DefaultScreenSize)
    if game.title.isNone():
        game.title = some(DefaultTitle)
    game.testBehavior.initialize()

func update(game: var Game) =
    if game.testBehavior.isEnabled and game.testBehavior.isInitialized:
        game.testBehavior.update(GetFrameTime())

func run*(game: var Game) =
    if not game.isRunning:
        game.initialize()

        TraceLog(LOG_INFO, "Starting...")
        InitWindow(
            int32(game.screenSize.get().x),
            int32(game.screenSize.get().y),
            game.title.get(),
        )
        SetTargetFPS(60)

        while not WindowShouldClose():
            game.update()
            game.draw()

func setClearColor*(game: var Game; clearColor: Color) =
    game.clearColor = some(clearColor)

func setScreenSize*(game: var Game; screenSize: Vector2) =
    if not game.isRunning:
        game.screenSize = some(screenSize)

func setTitle*(game: var Game; title: string) =
    if not game.isRunning:
        game.title = some(title)

func quit*(game: var Game) =
    if game.isRunning:
        game.isRunning = false
        CloseWindow()
