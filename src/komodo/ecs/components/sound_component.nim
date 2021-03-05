import ../../lib/audio

import ./component_macros

component SoundComponent:
  fields:
    sound: Sound

  create(soundPath: string):
    result.sound = newSound(soundPath)

  init:
    discard

  destroy:
    self.sound.destroy()

func sound*(self: SoundComponent): auto = self.sound
