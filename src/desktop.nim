import core/submodule
import lib/raylib

const screenSize = Vector2(
    x: 800,
    y: 450,
)

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

proc setupWindow() =
    InitWindow(int32(screenSize.x), int32(screenSize.y), "Hello World")
    SetTargetFPS(60)

proc loop() =
    TraceLog(LOG_INFO, "Starting...")
    while (not WindowShouldClose()):
        BeginDrawing()
        
        ClearBackground(RAYWHITE)

        "Hello world".drawCenteredText(
            Vector2(
                x: screenSize.x / 2,
                y: screenSize.y / 2,
            ),
            20,
            BLACK,
        )

        EndDrawing()
    TraceLog(LOG_INFO, "Closing...")
    CloseWindow()
    TraceLog(LOG_INFO, "Closed...")

when isMainModule:
    echo(getWelcomeMessage())
    setupWindow()
    loop()
