import lib/private/raylib

func logInfo*(message: string) =
    TraceLog(LOG_INFO, message)
