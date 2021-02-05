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

  Inputs = Keys | MouseButtons

var actionMap {.global.}: Table[string, Action]

proc newAction*(action: string): Action =
  if actionMap.hasKey(action):
    result = actionMap[action]
  else:
    result = Action(
      name: action,
      keyInputs: @[],
      mouseInputs: @[],
    )
    actionMap[action] = result

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

proc clear*(self: Action) =
  actionMap.del(self.name)
  self.keyInputs = @[]
  self.mouseInputs = @[]

proc clear*(self: string) =
  if self in actionMap:
    actionMap[self].clear()

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

proc map*(self: Action; input: Inputs): Action {.discardable.} =
  if not (self.name in actionMap):
    actionMap[self.name] = self
  if input is Keys:
    if not (input.Keys in self.keyInputs):
      self.keyInputs &= input.Keys
  elif input is MouseButtons:
    if not (input.MouseButtons in self.mouseInputs):
      self.mouseInputs &= input.MouseButtons
  self

proc map*(self: string; input: Inputs): Action {.discardable.} =
  if not (self in actionMap):
    actionMap[self] = newAction(self)
  actionMap[self].map(input)

proc map*(self: string; inputs: openArray[Inputs]): Action {.discardable.} =
  for input in inputs:
    result = self.map(input)

proc map*(self: Action; inputs: openArray[Inputs]): Action {.discardable.} =
  for input in inputs:
    result = self.map(input)

proc unmap*(self: Action; input: Inputs) =
  if self.name in actionMap:
    self.inputs = self.inputs.filter(x => x != input)
  else:
    logInfo(fmt"Action map did not contain action '{self.name}'")

proc unmap*(self: string; input: Inputs) =
  if self in actionMap:
    actionMap[self].unmap(input)
  else:
    logInfo(fmt"Action map did not contain action '{self}'")

proc unmap*(self: string; inputs: openArray[Inputs]) =
  for input in inputs:
    self.unmap(input)

proc unmap*(self: Action; inputs: openArray[Inputs]) =
  for input in inputs:
    self.unmap(input)
