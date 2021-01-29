import macros
import strformat


proc toConcreteTypeName(typeName: NimNode): string = fmt"{$typeName}Obj"

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

proc generateTypeDefinition*(
    typeName: NimNode;
    statements: NimNode;
    parentTypeName: string;
): NimNode =
    expectKind(typeName, nnkIdent)
    let fields = toFieldDefinitions(statements)
    let concreteTypeName = toConcreteTypeName(typeName)
    result = newTree(
        nnkTypeSection,
        newTree(
            nnkTypeDef,
            ident(concreteTypeName),
            newEmptyNode(),
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
            ),
        ),
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
                ident(concreteTypeName),
            ),
        ),
    )

proc generateInit*(
    typeName: NimNode;
    initDefinition: NimNode;
    defaultStatements: NimNode;
    lockLevel: NimNode;
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
        newTree(
            nnkPragma,
            newTree(
                nnkExprColonExpr,
                ident("locks"),
                lockLevel,
            )
        ),
        newEmptyNode(),
        quote do:
            `defaultStatements`
            `initBody`
    )

proc generateDestructor*(
    typeName: NimNode;
    destructorDefinition: NimNode;
    defaultStatements: NimNode = newEmptyNode();
): NimNode =
    expectKind(typeName, nnkIdent)
    let destructorSignature = destructorDefinition[0]
    expectIdent(destructorSignature, "destroy")
    let destructorBody = destructorDefinition[1]
    expectKind(destructorBody, nnkStmtList)
    
    result = newTree(
        nnkProcDef,
        newTree(
            nnkAccQuoted,
            ident("="),
            ident("destroy"),
        ),
        newEmptyNode(),
        newEmptyNode(),
        newTree(
            nnkFormalParams,
            newEmptyNode(),
            newTree(
                nnkIdentDefs,
                ident("self"),
                newTree(
                    nnkVarTy,
                    ident(toConcreteTypeName(typeName)),
                ),
                newEmptyNode(),
            ),
        ),
        newEmptyNode(),
        newEmptyNode(),
        quote do:
            `destructorBody`
            `defaultStatements`
    )

func knownLockLevel*(level: BiggestInt): NimNode = newIntLitNode(level)
func unknownLockLevel*: NimNode = newStrLitNode("unknown")