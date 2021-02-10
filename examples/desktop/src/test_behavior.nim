include komodo/prelude

from komodo/game import executeOnSystems, instance, deregisterComponent, registerComponent

behavior TestBehavior:
  fields:
    transform: Option[TransformComponent]
    move_action: Action
    remove_action: Action

  create:
    discard

  init:
    var transform = none[TransformComponent]()
    let game = instance.get()
    game.executeOnSystems(proc (system: System) =
      if transform.isNone():
        transform = system.findComponentByParent[:TransformComponent](
          self.parent.get().id,
        )
    )
    if transform.isNone():
      logError("Failed to find transform")
      return
    self.transform = transform

    self.move_action = newAction("move")
    self.move_action
      .map(Keys.Space)
      .map(Keys.D)

    self.remove_action = newAction("remove")
    self.remove_action
      .map(Keys.Delete)
      .map(Keys.Backspace)

  update:
    if self.move_action.isDown():
      let position = self.transform.get.position
      self.transform.get.position = Vector3(
          x: position.x + 1,
          y: position.y,
          z: position.z,
      )
    if self.remove_action.isDown():
      let game = instance.get()
      discard game.deregisterComponent(self.transform.get())
      discard game.registerComponent(self.transform.get())

  destroy:
    discard
