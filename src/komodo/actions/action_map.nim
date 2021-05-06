import tables

import ./action
import ./keyboard
import ./mouse

from sugar import collect

export action
export keyboard
export mouse


type
  ActionMap* = Table[ActionId, Action]

func newActionMap*(actions: seq[Action] = @[]): ActionMap =
  result = initTable[ActionId, Action]().ActionMap
  for action in actions:
    result[action.id] = action

func checkInputState(
  action: Action;
  keysPredicate: proc(key: Keys): bool {.noSideEffect, gcsafe, locks: 0.};
  mouseButtonsPredicate: proc(mouseButton: MouseButtons): bool {.noSideEffect, gcsafe, locks: 0.};
): bool =
  let keyInputs = action.keyInputs
  for input in keyInputs:
    if input.keysPredicate():
      return true
  let mouseInputs = action.mouseInputs
  for input in mouseInputs:
    if input.mouseButtonsPredicate():
      return true
  return false

func isDown*(self: ActionMap; id: ActionId): bool =
  if id in self:
    self[id].checkInputState(
      keyboard.isDown,
      mouse.isDown,
    )
  else:
    false

func isUp*(self: ActionMap; id: ActionId): bool =
  if id in self:
    self[id].checkInputState(
      keyboard.isUp,
      mouse.isUp,
    )
  else:
    false

func isPressed*(self: ActionMap; id: ActionId): bool =
  if id in self:
    self[id].checkInputState(
      keyboard.isPressed,
      mouse.isPressed,
    )
  else:
    false

func isReleased*(self: ActionMap; id: ActionId): bool =
  if id in self:
    self[id].checkInputState(
      keyboard.isReleased,
      mouse.isReleased,
    )
  else:
    false

