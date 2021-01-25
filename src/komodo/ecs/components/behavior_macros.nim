import macros

import ../../macro_helpers

import ./component
import ./behavior_component
import ../entity

from ../ids import nextComponentId

export component
export behavior_component
export entity
export nextComponentId

proc generateBehaviorConstructor(typeName: NimNode; constructorDefinition: NimNode): NimNode =
    expectKind(typeName, nnkIdent)
    expectKind(constructorDefinition, nnkCall)
    let constructorSignature = constructorDefinition[0]
    let constructorBody = constructorDefinition[1]
    expectKind(constructorBody, nnkStmtList)
    
    let formalParams = generateFormalParams(typeName, constructorSignature)
    formalParams.add(
        newIdentDefs(
            ident("parent"),
            ident("Entity"),
            newEmptyNode(),
        )
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

proc generateUpdate(typeName: NimNode; updateDefinition: NimNode): NimNode =
    expectKind(typeName, nnkIdent)
    let updateSignature = updateDefinition[0]
    expectIdent(updateSignature, "update")
    let updateBody = updateDefinition[1]
    expectKind(updateBody, nnkStmtList)
    
    result = newTree(
        nnkMethodDef,
        newTree(
            nnkPostfix,
            ident("*"),
            ident("update"),
        ),
        newEmptyNode(),
        newEmptyNode(),
        newTree(
            nnkFormalParams,
            newEmptyNode(),
            newTree(
                nnkIdentDefs,
                ident("self"),
                ident($typeName),
                newEmptyNode(),
            ),
            newTree(
                nnkIdentDefs,
                ident("delta"),
                ident("float32"),
                newEmptyNode(),
            ),
        ),
        newEmptyNode(),
        newEmptyNode(),
        quote do:
            `updateBody`
    )

macro behavior*(typeName: untyped; statements: untyped): untyped =
    result = newStmtList()
    expectKind(statements, nnkStmtList)
    result.add(
        generateRefTypeDefinition(
            typeName,
            statements[0],
            "BehaviorComponent",
        ),
    )
    result.add(
        generateBehaviorConstructor(
            typeName,
            statements[1],
        ),
    )
    result.add(
        generateInit(
            typeName,
            statements[2],
            quote do:
                discard
        ),
    )
    result.add(
        generateUpdate(
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
