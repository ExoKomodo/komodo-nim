import iup

import ./element

type
  Label* = ref object of Element

func newLabel*(text: string): Label =
  result = Label()
  result.inner = iup.label(text)
