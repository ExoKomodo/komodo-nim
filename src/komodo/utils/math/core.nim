from ../private/raymath import nil


func clamp*(value: float32; minimum: float32; maximum: float32): float32 =
  raymath.Clamp(value, minimum, maximum)

func lerp*(start: float32; `end`: float32; amount: float32): float32 =
  raymath.Lerp(start, `end`, amount)

func normalize*(value: float32; start: float32; `end`: float32): float32 =
  raymath.Normalize(value, start, `end`)

func map*(
  value: float32;
  input_start: float32;
  input_end: float32;
  output_start: float32;
  output_end: float32;
): float32 =
  raymath.Remap(
    value,
    input_start,
    input_end,
    output_start,
    output_end,
  )

