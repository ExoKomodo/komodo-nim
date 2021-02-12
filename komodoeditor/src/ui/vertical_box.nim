import iup

import ./element

type
  VerticalBox* = ref object of Element

func newVerticalBox*(children: varargs[Element]): VerticalBox =
  result = VerticalBox()
  result.inner = iup.vbox(nil)

  for child in children:
    result.addChild(child)
