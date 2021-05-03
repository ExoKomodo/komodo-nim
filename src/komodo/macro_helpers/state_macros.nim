import macros


func traverse(state: NimNode): NimNode =
  if state.kind != nnkDotExpr:
    state
  else:
    state[0].traverse()

func get_field(state_expression: NimNode; new_state: NimNode): NimNode =
  let field = state_expression
  var current_field = field
  while current_field.kind == nnkDotExpr:
    if current_field[0].kind == nnkIdent:
      current_field[0] = new_state
    current_field = current_field[0]
  field

func get_state(state_expression: NimNode): NimNode =
  let state = traverse(state_expression)
  state.expectKind(nnkIdent)
  state

func updated*(value: NimNode; initial_state: NimNode): NimNode =
  initial_state.expectKind(nnkDotExpr)
  
  let new_state = ident"new_state"
  let state = initial_state.get_state()
  let field = initial_state.get_field(new_state)
  result = quote do:
    block:
      var `new_state` = `state`
      `field` = `value`
      `new_state`

macro `|>`*(value: untyped; initial_state: untyped): untyped =
  value.updated(initial_state)

macro `<|`*(initial_state: untyped; value: untyped): untyped =
  value.updated(initial_state)

