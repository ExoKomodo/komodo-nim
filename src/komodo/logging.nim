from ./lib/private/raylib import TraceLog, TraceLogType, TraceLogType2int32

func logDebug*(message: string) =
    TraceLog(LOG_DEBUG, message)

func logInfo*(message: string) =
    TraceLog(LOG_INFO, message)

func logError*(message: string) =
    TraceLog(LOG_ERROR, message)
