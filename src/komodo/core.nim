import lib/private/raylib
import options

proc getWelcomeMessage*(): string =
    "Hello, World!"

proc getCenterOffset(text: cstring; fontSize: int32): int32 =
    MeasureText(text, fontSize) div 2

proc drawCenteredText(text: cstring; position: Vector2; fontSize: int32; color: Color) =
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

type Game* = object
    isRunning: bool
    screenSize: Option[Vector2]
    clearColor: Option[Color]
    title: Option[string]

proc draw(game: Game) =
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

proc initialize(game: var Game) =
    game.isRunning = true
    if game.clearColor.isNone():
        game.clearColor = some(RAYWHITE)
    if game.screenSize.isNone():
        game.screenSize = some(DefaultScreenSize)
    if game.title.isNone():
        game.title = some(DefaultTitle)

proc update(game: var Game) =
    discard

proc run*(game: var Game) =
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

proc setClearColor*(game: var Game; clearColor: Color) =
    game.clearColor = some(clearColor)

proc setScreenSize*(game: var Game; screenSize: Vector2) =
    if not game.isRunning:
        game.screenSize = some(screenSize)

proc setTitle*(game: var Game; title: string) =
    if not game.isRunning:
        game.title = some(title)

proc quit*(game: var Game) =
    if game.isRunning:
        game.isRunning = false
        CloseWindow()
