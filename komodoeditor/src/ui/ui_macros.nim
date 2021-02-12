import macros

from ./element import Callback


macro callback*(statements: untyped): Callback =
  expectKind(statements, nnkStmtList)

  result = newTree(
    nnkLambda,
    newEmptyNode(),
    newEmptyNode(),
    newEmptyNode(),
    newTree(
      nnkFormalParams,
      ident("CallbackCode"),
      newTree(
        nnkIdentDefs,
        ident("element"),
        ident("InnerElement"),
        newEmptyNode(),
      )
    ),
    newTree(
      nnkPragma,
      ident("cdecl"),
    ),
    newEmptyNode(),
    statements,
  )
