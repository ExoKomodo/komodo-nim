import ./data_bag

export data_bag


type
  MessageKind* = distinct string
  Message* = object
    kind: MessageKind
    data: DataBag

func `==`*(a, b: MessageKind): bool {.borrow.}
func `==`*(a: string, b: MessageKind): bool = a.MessageKind == b
func `==`*(a: MessageKind, b: string): bool = a == b.MessageKind
converter string2messagekind*(kind: string): MessageKind = kind.MessageKind
converter messagekind2string*(kind: MessageKind): string = kind.string

func data*(self: Message): auto = self.data
func kind*(self: Message): auto = self.kind

func newMessage*(
  kind: MessageKind;
  data: DataBag;
): Message = Message(
  data: data,
  kind: kind,
)

