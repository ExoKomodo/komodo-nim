import macros

import ../../macro_helpers
import ./system

export system

proc generateSystemConstructor(typeName: NimNode; constructorDefinition: NimNode): NimNode =
    expectKind(typeName, nnkIdent)
    expectKind(constructorDefinition, nnkCall)
    let constructorSignature = constructorDefinition[0]
    let constructorBody = constructorDefinition[1]
    expectKind(constructorBody, nnkStmtList)
    
    let formalParams = generateFormalParams(typeName, constructorSignature)
    formalParams.add(
        newIdentDefs(
            ident("isEnabled"),
            ident("bool"),
            ident("true"),
        )
    )

    let defaultStatements = newStmtList(
        (
            quote do:
                result = `typeName`()
        ),
        newCall(
            bindSym("isEnabled="),
            ident("result"),
            ident("isEnabled"),
        ),
    )
    result = generateConstructor(
        typeName,
        formalParams,
        defaultStatements,
        constructorBody,
    )

proc generateDrawOrUpdate(typeName: NimNode; procDefinition: NimNode): NimNode =
    expectKind(typeName, nnkIdent)
    let procSignature = procDefinition[0]
    var isUpdate: bool = false
    case $procSignature:
    of "update":
        isUpdate = true
    of "draw":
        isUpdate = false
    else:
        raiseAssert("Must contain either draw or update block")

    let procBody = procDefinition[1]
    expectKind(procBody, nnkStmtList)

    let formalParams = newTree(
        nnkFormalParams,
        newEmptyNode(),
        newTree(
            nnkIdentDefs,
            ident("self"),
            ident($typeName),
            newEmptyNode(),
        ),
    )
    if isUpdate:
        formalParams.add(
            newTree(
                nnkIdentDefs,
                ident("delta"),
                ident("float32"),
                newEmptyNode(),
            ),
        )

    
    result = newTree(
        nnkMethodDef,
        newTree(
            nnkPostfix,
            ident("*"),
            ident($procSignature),
        ),
        newEmptyNode(),
        newEmptyNode(),
        formalParams,
        newEmptyNode(),
        newEmptyNode(),
        quote do:
            `procBody`
    )

macro system*(typeName: untyped; statements: untyped): untyped =
    result = newStmtList()
    expectKind(statements, nnkStmtList)
    result.add(
        generateRefTypeDefinition(
            typeName,
            statements[0],
            "System",
        ),
    )
    result.add(
        generateSystemConstructor(
            typeName,
            statements[1],
        ),
    )
    result.add(
        generateInit(
            typeName,
            statements[2],
            quote do:
                procCall self.System.initialize()
        ),
    )
    result.add(
        generateDrawOrUpdate(
            typeName,
            statements[3],
        ),
    )
    result.add(
        generateFinalizer(
            typeName,
            statements[4],
        ),
    )
