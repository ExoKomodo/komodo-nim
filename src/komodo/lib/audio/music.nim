import options

from ../private/raylib import nil


template injectRaylibMusic(self: typed; music: untyped) =
  if self.music.isNone:
    return
  let music: raylib.Music = self.music.unsafeGet()

type
  Music* = ref object of RootObj
    music: Option[raylib.Music]

func unload(self: Music) =
  if self.music.isSome:
    raylib.UnloadMusicStream(self.music.unsafeGet())
    self.music = none[raylib.Music]()

func destroy*(self: Music) =
  self.unload()

func newMusic*(musicPath: string): Music =
  result = Music(
      music: some(raylib.LoadMusicStream(musicPath))
  )

func isPlaying*(self: Music): bool =
  self.injectRaylibMusic(music)
  result = raylib.IsMusicPlaying(music)

func pause*(self: Music) =
  self.injectRaylibMusic(music)
  raylib.PauseMusicStream(music)

func play*(self: Music) =
  self.injectRaylibMusic(music)
  raylib.PlayMusicStream(music)

func resume*(self: Music) =
  self.injectRaylibMusic(music)
  raylib.ResumeMusicStream(music)

func stop*(self: Music) =
  self.injectRaylibMusic(music)
  raylib.StopMusicStream(music)

func `volume=`(self: Music; volume: float32) =
  self.injectRaylibMusic(music)
  raylib.SetMusicVolume(music, volume)

func `pitch=`(self: Music; pitch: float32) =
  self.injectRaylibMusic(music)
  raylib.SetMusicPitch(music, pitch)
