import options

from ../private/raylib import nil


template injectRaylibSound(self: typed; sound: untyped) =
  if self.sound.isNone:
    return
  let sound: raylib.Sound = self.sound.unsafeGet()

type
  Sound* = ref object of RootObj
    sound: Option[raylib.Sound]

func unload(self: Sound) =
  if self.sound.isSome:
    raylib.UnloadSound(self.sound.unsafeGet())
    self.sound = none[raylib.Sound]()

func destroy*(self: Sound) =
  self.unload()

func newSound*(soundPath: string): Sound =
  result = Sound(
      sound: some(raylib.LoadSound(soundPath))
  )

func isPlaying*(self: Sound): bool =
  self.injectRaylibSound(sound)
  result = raylib.IsSoundPlaying(sound)

func pause*(self: Sound) =
  self.injectRaylibSound(sound)
  raylib.PauseSound(sound)

func play*(self: Sound) =
  self.injectRaylibSound(sound)
  raylib.PlaySound(sound)

func resume*(self: Sound) =
  self.injectRaylibSound(sound)
  raylib.ResumeSound(sound)

func stop*(self: Sound) =
  self.injectRaylibSound(sound)
  raylib.StopSound(sound)

func `volume=`(self: Sound; volume: float32) =
  self.injectRaylibSound(sound)
  raylib.SetSoundVolume(sound, volume)

func `pitch=`(self: Sound; pitch: float32) =
  self.injectRaylibSound(sound)
  raylib.SetSoundPitch(sound, pitch)
