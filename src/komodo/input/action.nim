import sequtils
import strformat
import tables

import ./keyboard
import ./mouse
import ../logging

from sugar import `=>`

type
  Action* = ref object
    keyInputs: seq[Keys]
    mouseInputs: seq[MouseButtons]
    name: string
  
  ActionManager* = ref object
    actionMap: Table[string, Action]

  Inputs = Keys | MouseButtons

proc newActionManager*(): ActionManager =
  result = ActionManager()

proc newAction*(self: ActionManager; action: string): Action =
  if self.actionMap.hasKey(action):
    result = self.actionMap[action]
  else:
    result = Action(
      name: action,
      keyInputs: @[],
      mouseInputs: @[],
    )
    self.actionMap[action] = result

func name*(self: Action): string = self.name

func checkInputState(
  keyInputs: seq[Keys];
  keysPredicate: proc(key: Keys): bool;
  mouseInputs: seq[MouseButtons];
  mouseButtonsPredicate: proc(mouseButton: MouseButtons): bool;
): bool =
  for input in keyInputs:
    if input.keysPredicate():
      return true
  for input in mouseInputs:
    if input.mouseButtonsPredicate():
      return true
  return false

proc clear*(self: ActionManager; action: Action) =
  self.actionMap.del(action.name)
  action.keyInputs = @[]
  action.mouseInputs = @[]

proc clear*(self: ActionManager; action: string) =
  if action in self.actionMap:
    self.clear(self.actionMap[action])

func isDown*(self: Action): bool =
  checkInputState(
    self.keyInputs,
    keyboard.isDown,
    self.mouseInputs,
    mouse.isDown,
  )

func isUp*(self: Action): bool =
  checkInputState(
    self.keyInputs,
    keyboard.isUp,
    self.mouseInputs,
    mouse.isUp,
  )

func isPressed*(self: Action): bool =
  checkInputState(
    self.keyInputs,
    keyboard.isPressed,
    self.mouseInputs,
    mouse.isPressed,
  )

func isReleased*(self: Action): bool =
  checkInputState(
    self.keyInputs,
    keyboard.isReleased,
    self.mouseInputs,
    mouse.isReleased,
  )

proc map*(self: ActionManager; action: Action; input: Inputs): ActionManager {.discardable.} =
  if not (action.name in self.actionMap):
    self.actionMap[action.name] = action
  if input is Keys:
    if not (input.Keys in action.keyInputs):
      action.keyInputs &= input.Keys
  elif input is MouseButtons:
    if not (input.MouseButtons in action.mouseInputs):
      action.mouseInputs &= input.MouseButtons
  self

proc map*(self: ActionManager; action: string; input: Inputs): ActionManager {.discardable.} =
  if not (action in self.actionMap):
    self.actionMap[action] = self.newAction(action)
  self.actionMap[action].map(input)

proc map*(self: ActionManager; action: string; inputs: openArray[Inputs]): ActionManager {.discardable.} =
  for input in inputs:
    result = self.map(action, input)

proc map*(self: ActionManager; action: Action; inputs: openArray[Inputs]): ActionManager {.discardable.} =
  for input in inputs:
    result = self.map(action, input)

proc unmap*(self: ActionManager; action: Action; input: Inputs) =
  if action.name in self.actionMap:
    action.inputs = action.inputs.filter(x => x != input)
  else:
    logInfo(fmt"Action map did not contain action '{action.name}'")

proc unmap*(self: ActionManager; action: string; input: Inputs) =
  if action in self.actionMap:
    self.actionMap[action].unmap(action, input)
  else:
    logInfo(fmt"Action map did not contain action '{action}'")

proc unmap*(self: ActionManager; action: string; inputs: openArray[Inputs]) =
  for input in inputs:
    self.unmap(action, input)

proc unmap*(self: ActionManager; action: Action; inputs: openArray[Inputs]) =
  for input in inputs:
    self.unmap(action, input)
