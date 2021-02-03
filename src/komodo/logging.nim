from ./lib/private/raylib import nil, TraceLogType2int32

func logDebug*(message: string) =
  raylib.TraceLog(raylib.LOG_DEBUG, message)

func logInfo*(message: string) =
  raylib.TraceLog(raylib.LOG_INFO, message)

func logError*(message: string) =
  raylib.TraceLog(raylib.LOG_ERROR, message)
