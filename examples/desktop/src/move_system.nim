import komodo/prelude

import strformat

import komodo/ecs/systems/system_macros
import komodo/lib/audio


func move(
  transform: TransformComponent;
  xDirection: float = 0;
  yDirection: float = 0;
  delta: float32 = 0;
) =
  let position = transform.position
  transform.position = Vector3(
      x: position.x + (100 * xDirection) * delta,
      y: position.y + (100 * yDirection) * delta,
      z: position.z,
  )

system MoveSystem:
  fields:
    action_manager: ActionManager
    move_left_action: Action
    move_right_action: Action
    move_up_action: Action
    move_down_action: Action
    sound_action: Action

  create:
    discard

  init:
    self.action_manager = newActionManager()
    self.move_left_action = self.action_manager.newAction("move_left")
    self.move_right_action = self.action_manager.newAction("move_right")
    self.move_up_action = self.action_manager.newAction("move_up")
    self.move_down_action = self.action_manager.newAction("move_down")
    self.sound_action = self.action_manager.newAction("sound")
    self.action_manager
      .map(self.move_left_action, Keys.Left)
      .map(self.move_left_action, Keys.A)
      .map(self.move_right_action, Keys.Right)
      .map(self.move_right_action, Keys.D)
      .map(self.move_up_action, Keys.Up)
      .map(self.move_up_action, Keys.W)
      .map(self.move_down_action, Keys.Down)
      .map(self.move_down_action, Keys.S)
      .map(self.sound_action, Keys.Space)

  update:
    for entity_id, components in pairs(self.entityToComponents):
      if self.findComponentByParent[:SpriteComponent](entity_id).isNone:
        continue
      
      let textOpt = self.findComponentByParent[:TextComponent](entity_id)
      if textOpt.isNone:
        continue
      let text = textOpt.unsafeGet()
      
      let transformOpt = self.findComponentByParent[:TransformComponent](entityId)
      if transformOpt.isNone:
        continue
      let transform = transformOpt.unsafeGet()
      
      let soundOpt = self.findComponentByParent[:SoundComponent](entityId)
      if soundOpt.isNone:
        continue
      let sound = soundOpt.unsafeGet()
      
      if self.move_left_action.isDown():
        move(transform, xDirection = -1, delta = delta,)
      if self.move_right_action.isDown():
        move(transform, xDirection = 1, delta = delta,)
      if self.move_up_action.isDown():
        move(transform, yDirection = -1, delta = delta,)
      if self.move_down_action.isDown():
        move(transform, yDirection = 1, delta = delta,)
      
      text.text = fmt"Hello from Desktop: {getFps()} FPS"
      if self.sound_action.isPressed():
        if sound.sound.isPlaying():
          sound.sound.pause()
        else:
          sound.sound.play()

  destroy:
    discard

method hasNecessaryComponents*(
    self: MoveSystem;
    entity: Entity;
    components: seq[Component];
): bool =
  not (
      self.findComponentByParent[:SpriteComponent](entity).isNone or
      self.findComponentByParent[:TextComponent](entity).isNone or
      self.findComponentByParent[:TransformComponent](entity).isNone or
      self.findComponentByParent[:SoundComponent](entity).isNone
  )
