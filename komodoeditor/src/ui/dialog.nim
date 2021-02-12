import iup

import ./element

type
  Dialog* = ref object of Element

func newDialog*(children: varargs[Element]): Dialog =
  result = Dialog()
  result.inner = iup.dialog(nil)

  for child in children:
    result.addChild(child)

func show*(self: Dialog; x: int = iup.IUP_CENTER; y: int = iup.IUP_CENTER) =
  self.inner.showXY(x.cint, y.cint)
