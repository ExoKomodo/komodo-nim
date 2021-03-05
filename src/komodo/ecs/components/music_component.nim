import ../../lib/audio

import ./component_macros

component MusicComponent:
  fields:
    music: Music

  create(musicPath: string):
    result.music = newMusic(musicPath)

  init:
    discard

  destroy:
    self.music.destroy()

func music*(self: MusicComponent): auto = self.music
