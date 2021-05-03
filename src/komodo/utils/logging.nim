from ./private/raylib import nil, TraceLogType2int32

func log_debug*(message: string) =
  raylib.TraceLog(raylib.LOG_DEBUG, message)

func log_info*(message: string) =
  raylib.TraceLog(raylib.LOG_INFO, message)

proc log_error*(message: string) {.sideEffect.} =
  raylib.TraceLog(raylib.LOG_ERROR, message)

