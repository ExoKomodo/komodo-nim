import os

import komodo/game
import ./game_window
import ./ui

from iup import open, close, mainLoop

var gameThread: Thread[ptr Channel[CommandKind]]
var channel: ptr Channel[CommandKind]
var isRunning: bool

proc sendCloseCommand(): CallbackCode {.cdecl.} =
  if isRunning:
    channel[].send(CommandKind.Close)
    gameThread.joinThread()
    isRunning = false
  DefaultCallbackCode

proc startGame(): CallbackCode {.cdecl.} =
  if not isRunning:
    isRunning = true
    createThread(gameThread, game_window.start, channel)
  DefaultCallbackCode

proc generateSkeleton(channel: ptr Channel[CommandKind]) =
  let startCallback = callback:
    startGame()
  let startButton = newButton(
    "Start",
    startCallback,
  )
  
  let closeCallback = callback:
    sendCloseCommand()
  let closeButton = newButton(
    "Close Game",
    closeCallback,
  )
  let label = newLabel("Welcome to the Komodo Editor")
  let vertical_box = newVerticalBox(
    label,
    startButton,
    closeButton,
  )
  vertical_box[AlignmentAttribute] = "ACENTER"
  vertical_box[GapAttribute] = 10
  vertical_box[MarginAttribute] = createDimensionAttribute(100, 10)

  let dialog = newDialog(vertical_box)
  dialog[TitleAttribute] = "Komodo Editor"

  dialog.show()

proc init(channel: ptr Channel[CommandKind]) = 
  var argc = create(cint)
  argc[] = paramCount().cint
  var argv = allocCstringArray(commandLineParams())
  assert iup.open(argc, argv.addr) == 0         # UIP requires calling open()

  channel[].open()
  generateSkeleton(channel)

proc close(channel: ptr Channel[CommandKind]) = 
  iup.close()
  channel[].close()

proc run() =
  iup.mainLoop()

when isMainModule:
  channel = cast[ptr Channel[CommandKind]](
    allocShared0(sizeof(Channel[CommandKind]))
  )
  init(channel)
  run()
  close(channel)
  deallocShared(channel)
