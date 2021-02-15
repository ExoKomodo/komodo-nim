import iup
import strformat
import strutils

import ./element


type
  Branch* = object
    id: int
    text: string

  Leaf* = object
    id: int
    text: string

  TreeElement* = Branch | Leaf

  Tree* = ref object of Element

const
  TreeNextIdAttribute* = "LASTADDNODE".ElementAttribute
  TreeAddBranchAttribute* = "ADDBRANCH".ElementAttribute
  TreeAddLeafAttribute* = "ADDLEAF".ElementAttribute

func newBranch(id: int; text: string): auto = Branch(
  id: id,
  text: text,
)

func newLeaf(id: int; text: string): auto = Leaf(
  id: id,
  text: text,
)

func id*(self: TreeElement): int = self.id
func text*(self: TreeElement): string = self.text

func setCallback(self: Tree; action: string; callback: Callback) {.inline.} =
  self.inner.setCallback(
    action,
    callback,
  )

func currentId(self: Tree): int =
  let id = $self[TreeNextIdAttribute]
  if id == "":
    -1
  else:
    id.parseInt()

func createBranch*(self: Tree; text: string): Branch =
  self[TreeAddBranchAttribute] = text
  newBranch(
    self.currentId,
    text,
  )

func createBranch*(self: Tree; text: string; parent: TreeElement): Branch =
  self.inner.setAttribute(fmt"ADDBRANCH{parent.id.int}", text)
  newBranch(
    self.currentId,
    text,
  )

func createLeaf*(self: Tree; text: string): Leaf =
  self[TreeAddLeafAttribute] = text
  newLeaf(
    self.currentId,
    text,
  )

func createLeaf*(self: Tree; text: string; parent: TreeElement): Leaf =
  self.inner.setAttribute(fmt"ADDLEAF{parent.id.int}", text)
  newLeaf(
    self.currentId,
    text,
  )

func `beforeRename=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "SHOWRENAME_CB",
    callback,
  )

func `branchCollapsed=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "BRANCHCLOSE_CB",
    callback,
  )

func `branchExecute=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "EXECUTEBRANCH_CB",
    callback,
  )

func `branchExpanded=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "BRANCHOPEN_CB",
    callback,
  )

func `dragged=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "DRAGDROP_CB",
    callback,
  )

func `keyPressed=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "K_ANY",
    callback,
  )

func `leafExecute=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "EXECUTELEAF_CB",
    callback,
  )

func `nodeRemoved=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "NODEREMOVED_CB",
    callback,
  )

func `rename=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "RENAME_CB",
    callback,
  )

func `rightClicked=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "RIGHTCLICK_CB",
    callback,
  )

func `selected=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "SELECTION_CB",
    callback,
  )

func `selectedMultiple=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "MULTISELECTION_CB",
    callback,
  )

func `toggled=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "TOGGLEVALUE_CB",
    callback,
  )

func `unselectedMultiple=`*(self: Tree; callback: Callback) {.inline.} =
  self.setCallback(
    "MULTIUNSELECTION_CB",
    callback,
  )

func newTree*(title: string): auto =
  result = Tree()
  result.inner = iup.tree()
  result[TitleAttribute] = title
