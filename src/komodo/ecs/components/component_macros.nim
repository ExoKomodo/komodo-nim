import macros

import ../../private/macro_helpers

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
    let typeDefinition = generateTypeDefinition(
        typeName,
        statements[0],
        "Component",
    )
    let constructor = generateComponentConstructor(
        typeName,
        statements[1],
    )
    let initializer = generateInit(
        typeName,
        statements[2],
        (
            quote do:
                procCall self.Component.initialize()
        ),
        unknownLockLevel(),
    )
    let destructor = generateDestructor(
        typeName,
        statements[3],
    )
    
    result.add(typeDefinition)
    result.add(destructor)
    result.add(constructor)
    result.add(initializer)
