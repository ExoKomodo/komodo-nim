import macros

import ../../macro_helpers

import ./component
import ../entity

from ../ids import nextComponentId

export component
export entity
export nextComponentId

proc generateComponentConstructor(typeName: NimNode; constructorDefinition: NimNode): NimNode =
    expectKind(typeName, nnkIdent)
    expectKind(constructorDefinition, nnkCall)
    let constructorSignature = constructorDefinition[0]
    let constructorBody = constructorDefinition[1]
    expectKind(constructorBody, nnkStmtList)
    
    var formalParams = newTree(
        nnkFormalParams,
        ident($typeName),
    )
    formalParams.add(
        newIdentDefs(
            ident("parent"),
            ident("Entity"),
            newEmptyNode(),
        )
    )
    formalParams = generateFormalParams(
        typeName,
        constructorSignature,
        formalParams
    )
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
                result = `typeName`(
                    id: nextComponentId(),
                )
        ),
        newCall(
            bindSym("parent="),
            ident("result"),
            ident("parent"),
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

macro component*(typeName: untyped; statements: untyped): untyped =
    result = newStmtList()
    expectKind(statements, nnkStmtList)
    result.add(
        generateRefTypeDefinition(
            typeName,
            statements[0],
            "Component",
        ),
    )
    result.add(
        generateComponentConstructor(
            typeName,
            statements[1],
        ),
    )
    result.add(
        generateInit(
            typeName,
            statements[2],
            quote do:
                procCall self.Component.initialize()
        ),
    )
    result.add(
        generateFinalizer(
            typeName,
            statements[3],
        ),
    )
