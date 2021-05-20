import komodo/message

const
  left_click* = "left_click".MessageKind

func newLeftClickMessage*(): Message =
  newMessage(left_click)

