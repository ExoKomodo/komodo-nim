import macros
import strformat

proc toFieldDefinitions(fields: NimNode): seq[NimNode] =
    result = @[]
    expectKind(fields, nnkCall)
    expectIdent(fields[0], "fields")
    expectKind(fields[1], nnkStmtList)
    
    for field in fields[1]:
        if field.kind == nnkDiscardStmt:
            break
        expectKind(field, nnkCall)
        
        let fieldName = field[0]
        expectKind(fieldName, nnkIdent)
        
        let fieldStatements = field[1]
        expectKind(fieldStatements, nnkStmtList)
        
        let fieldType = fieldStatements[0]
        expectKind(fieldType, nnkIdent)
        
        result.add(
            newIdentDefs(
                fieldName,
                fieldType,
            ),
        )

proc toFormalParam(param: NimNode): NimNode =
    expectKind(param, nnkExprColonExpr)
    
    let paramName = param[0]
    expectKind(paramName, nnkIdent)
    
    let paramType = param[1]
    expectKind(paramType, nnkIdent)

    var paramDefault = newEmptyNode()
    if param.len == 3:
        paramDefault = param[2]
        expectKind(paramDefault, nnkIdent)

    result = newIdentDefs(
        paramName,
        paramType,
        paramDefault,
    )

proc generateConstructor*(
    typeName: NimNode;
    formalParams: NimNode;
    defaultStatements: NimNode;
    constructorBody: NimNode;
): NimNode =
    expectKind(typeName, nnkIdent)
    expectKind(formalParams, nnkFormalParams)
    expectKind(defaultStatements, nnkStmtList)
    expectKind(constructorBody, nnkStmtList)
    result = newTree(
        nnkProcDef,
        newTree(
            nnkPostfix,
            ident("*"),
            ident(fmt"new{$typeName}"),
        ),
        newEmptyNode(),
        newEmptyNode(),
        formalParams,
        newEmptyNode(),
        newEmptyNode(),
        quote do:
            `defaultStatements`
            `constructorBody`
    )

proc generateFormalParams*(
    typeName: NimNode;
    constructorSignature: NimNode;
    startingParams: NimNode=nil;
): NimNode =
    if startingParams.isNil():
        result = newTree(
            nnkFormalParams,
            ident($typeName),
        )
    else:
        result = startingParams
    
    let hasParams = constructorSignature.kind != nnkIdent
    if hasParams:
        expectKind(constructorSignature, nnkObjConstr)
        expectIdent(constructorSignature[0], "create")
    else:
        expectIdent(constructorSignature, "create")

    if hasParams and constructorSignature.len > 1:
        let params = constructorSignature[1..<constructorSignature.len]
        for param in params:
            result.add(toFormalParam(param))

proc generateRefTypeDefinition*(
    typeName: NimNode;
    statements: NimNode;
    parentTypeName: string;
): NimNode =
    expectKind(typeName, nnkIdent)
    let fields = toFieldDefinitions(statements)
    result = newTree(
        nnkTypeSection,
        newTree(
            nnkTypeDef,
            newTree(
                nnkPostfix,
                ident("*"),
                ident($typeName),
            ),
            newEmptyNode(),
            newTree(
                nnkRefTy,
                newTree(
                    nnkObjectTy,
                    newEmptyNode(),
                    newTree(
                        nnkOfInherit,
                        ident(parentTypeName),
                    ),
                    newTree(
                        nnkRecList,
                        fields,
                    )
                )
            ),
        )
    )

proc generateInit*(
    typeName: NimNode;
    initDefinition: NimNode;
    defaultStatements: NimNode;
): NimNode =
    expectKind(typeName, nnkIdent)
    let initSignature = initDefinition[0]
    expectIdent(initSignature, "init")
    let initBody = initDefinition[1]
    expectKind(initBody, nnkStmtList)

    result = newTree(
        nnkMethodDef,
        newTree(
            nnkPostfix,
            ident("*"),
            ident("initialize"),
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
        ),
        newEmptyNode(),
        newEmptyNode(),
        quote do:
            `defaultStatements`
            `initBody`
    )

proc generateFinalizer*(typeName: NimNode; finalizerDefinition: NimNode): NimNode =
    expectKind(typeName, nnkIdent)
    let finalizerSignature = finalizerDefinition[0]
    expectIdent(finalizerSignature, "final")
    let finalizerBody = finalizerDefinition[1]
    expectKind(finalizerBody, nnkStmtList)
    
    result = newTree(
        nnkProcDef,
        newTree(
            nnkPostfix,
            ident("*"),
            ident("finalizer"),
        ),
        newEmptyNode(),
        newEmptyNode(),
        newTree(
            nnkFormalParams,
            ident($typeName),
            newTree(
                nnkIdentDefs,
                ident("self"),
                ident($typeName),
                newEmptyNode(),
            ),
        ),
        newEmptyNode(),
        newEmptyNode(),
        quote do:
            `finalizerBody`
    )