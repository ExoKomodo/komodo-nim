import ./color
import ../math

from ../private/raylib import nil


func getCenterOffset(
    text: string;
    fontSize: int32;
): int32 = raylib.MeasureText(text, fontSize) div 2

func draw*(
    text: string;
    position: Vector2D;
    fontSize: int32;
    color: Color;
) = raylib.DrawText(
    text,
    int32(position.x),
    int32(position.y),
    fontSize,
    color,
)

func drawCentered*(
    text: string;
    position: Vector2D;
    fontSize: int32;
    color: Color;
) =
    let centerPosition = Vector2(
        x: position.x - text.getCenterOffset(fontSize).float32,
        y: position.y,
    )
    draw(
        text,
        centerPosition,
        fontSize,
        color,
    )