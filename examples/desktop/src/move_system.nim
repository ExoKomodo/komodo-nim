include komodo/prelude

import strformat

import komodo/ecs/systems/system_macros


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

  create:
    discard

  init:
    self.action_manager = newActionManager()
    self.move_left_action = self.action_manager.newAction("move_left")
    self.move_right_action = self.action_manager.newAction("move_right")
    self.move_up_action = self.action_manager.newAction("move_up")
    self.move_down_action = self.action_manager.newAction("move_down")
    self.action_manager
      .map(self.move_left_action, Keys.Left)
      .map(self.move_left_action, Keys.A)
      .map(self.move_right_action, Keys.Right)
      .map(self.move_right_action, Keys.D)
      .map(self.move_up_action, Keys.Up)
      .map(self.move_up_action, Keys.W)
      .map(self.move_down_action, Keys.Down)
      .map(self.move_down_action, Keys.S)

  update:
    for entity_id, components in pairs(self.entityToComponents):
      if self.findComponentByParent[:SpriteComponent](entity_id).isNone():
        continue
      let text = self.findComponentByParent[:TextComponent](entity_id)
      if text.isNone():
        continue
      let transform = self.findComponentByParent[:TransformComponent](entityId)
      if transform.isNone():
        continue
      
      if self.move_left_action.isDown():
        move(transform.unsafeGet(), xDirection = -1, delta = delta,)
      if self.move_right_action.isDown():
        move(transform.unsafeGet(), xDirection = 1, delta = delta,)
      if self.move_up_action.isDown():
        move(transform.unsafeGet(), yDirection = -1, delta = delta,)
      if self.move_down_action.isDown():
        move(transform.unsafeGet(), yDirection = 1, delta = delta,)
      
      text.get.text = fmt"Hello from Desktop: {getFps()} FPS"

  destroy:
    discard
