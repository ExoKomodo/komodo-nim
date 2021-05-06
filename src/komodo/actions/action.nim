import ./keyboard
import ./mouse

export keyboard
export mouse


type
  ActionId* = string
  Action* = object
    id*: ActionId
    keyInputs*: seq[Keys]
    mouseInputs*: seq[MouseButtons]

converter string2actionid*(kind: string): ActionId = kind.ActionId
converter actionid2string*(kind: ActionId): string = kind.string

func newAction*(
  id: ActionId;
  keyInputs: seq[Keys] = @[];
  mouseInputs: seq[MouseButtons] = @[];
): Action =
  Action(
    id: id,
    keyInputs: keyInputs,
    mouseInputs: mouseInputs,
  )

