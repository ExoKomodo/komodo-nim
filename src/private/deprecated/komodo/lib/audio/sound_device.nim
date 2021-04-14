from ../private/raylib import nil

func initialize*() = raylib.InitAudioDevice()

func isReady*(): bool = raylib.IsAudioDeviceReady()

func close*() = raylib.CloseAudioDevice()

func setMasterVolume*(volume: float32) = raylib.SetMasterVolume(volume)
