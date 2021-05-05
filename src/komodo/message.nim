type
  MessageKind* = distinct string
  MessageDataObj = object of RootObj
  MessageData* = ref MessageDataObj
  Message* = object
    kind: MessageKind
    data: MessageData

func `==`*(a, b: MessageKind): bool {.borrow.}
func `==`*(a: string, b: MessageKind): bool = a.MessageKind == b
func `==`*(a: MessageKind, b: string): bool = a == b.MessageKind
converter string2messagekind*(kind: string): MessageKind = kind.MessageKind
converter messagekind2string*(kind: MessageKind): string = kind.string

func data*(self: Message): auto = self.data
func kind*(self: Message): auto = self.kind

func newMessage*(
  kind: MessageKind;
  data: MessageData;
): Message = Message(
  data: data,
  kind: kind,
)

