import os
import strformat

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

proc generateSkeleton(channel: ptr Channel[CommandKind]): tuple[vertical_box: VerticalBox, ecs_tree: Tree] =
  let start_callback = callback:
    startGame()
  let start_button = newButton(
    "Start",
    start_callback,
  )
  
  let close_callback = callback:
    sendCloseCommand()
  let close_button = newButton(
    "Close Game",
    close_callback,
  )

  let ecs_tree = newTree("ECS")

  let label = newLabel("Welcome to the Komodo Editor")
  let vertical_box = newVerticalBox(
    label,
    start_button,
    close_button,
    ecs_tree,
  )
  vertical_box[AlignmentAttribute] = "ACENTER"
  vertical_box[GapAttribute] = 10
  vertical_box[MarginAttribute] = createDimensionAttribute(20, 20)

  let dialog = newDialog(vertical_box)
  dialog[TitleAttribute] = "Komodo Editor"

  dialog.show()

  result.vertical_box = vertical_box
  result.ecs_tree = ecs_tree

func fillSkeleton(ecs_tree: Tree) =
  let systemsHierarchy = ecs_tree.createBranch(
    "Systems",
  )
  for x in 0..5:
    let id = 5 - x
    discard ecs_tree.createLeaf(
      fmt"System {id}",
      systemsHierarchy,
    )

  let componentsHierarchy = ecs_tree.createBranch(
    "Components",
  )
  for x in 0..5:
    let id = 5 - x
    discard ecs_tree.createLeaf(
      fmt"Component {id}",
      componentsHierarchy,
    )
  
  let entitiesHierarchy = ecs_tree.createBranch(
    "Entities",
  )
  for x in 0..5:
    let id = 5 - x
    discard ecs_tree.createLeaf(
      fmt"Entity {id}",
      entitiesHierarchy,
    )

proc init(channel: ptr Channel[CommandKind]) = 
  var argc = create(cint)
  argc[] = paramCount().cint
  var argv = allocCstringArray(commandLineParams())
  assert iup.open(argc, argv.addr) == 0         # UIP requires calling open()

  channel[].open()
  let (_, ecs_tree) = generateSkeleton(channel)
  fillSkeleton(ecs_tree)

proc close(channel: ptr Channel[CommandKind]) = 
  iup.close()
  channel[].close()

func run() =
  iup.mainLoop()

when isMainModule:
  channel = cast[ptr Channel[CommandKind]](
    allocShared0(sizeof(Channel[CommandKind]))
  )
  init(channel)
  run()
  close(channel)
  deallocShared(channel)
