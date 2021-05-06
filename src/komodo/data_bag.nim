type
  DataKind* = distinct string
  DataBagObj = object of RootObj
    kind*: DataKind
  DataBag* = ref DataBagObj

func `==`*(a, b: DataKind): bool {.borrow.}
func `==`*(a: string, b: DataKind): bool = a.DataKind == b
func `==`*(a: DataKind, b: string): bool = a == b.DataKind
converter string2datakind*(kind: string): DataKind = kind.DataKind
converter datakind2string*(kind: DataKind): string = kind.string

