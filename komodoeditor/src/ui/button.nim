import iup

import ./element

type
  Button* = ref object of Element

func `callback=`*(self: Button; callback: Callback) =
  self.inner.setCallback(
    "ACTION",
    callback,
  )

func newButton*(
  text: string;
): Button =
  result = Button()
  result.inner = iup.button(
    text,
    nil,
  )

func newButton*(
  text: string;
  callback: Callback;
): Button =
  result = newButton(text)
  result.callback = callback
