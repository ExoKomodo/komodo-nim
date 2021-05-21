import komodo/data_bag
import komodo/message

const
  left_click* = "left_click".MessageKind
  time_data* = "time".DataKind

type
  TimeData* = ref object of DataBag
    delta: float32

func delta*(self: TimeData): auto = self.delta

func newLeftClickMessage*(delta: float32): Message =
  newMessage(
    left_click,
    data=TimeData(
      kind: time_data,
      delta: delta,
    ),
  )
