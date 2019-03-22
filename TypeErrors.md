Compile-time Errors to implement:

| Section | Error Case | Planned | Implemented ?
|--:|--:|--:|--:|
| 3.10.1 | `\u` not followed with 4 hexadecimal digits | no | no |
| 3.10.1 | `int` > `2147483648` | yes | -- |
| 3.10.1 | `long` > `9223372036854775808L` | yes | -- |
| 3.10.2 | `float` > `3.4028235e38f` | yes | -- |
| 3.10.2 | `float` < `1.40e-45f` | yes | -- |
| 3.10.2 | `double` > `1.7976931348623157e308` | yes | -- |
| 3.10.2 | `double` < `4.9e-324` | yes | -- |
| 3.10.4 | "`'`" not following *SingleCharacter* or *EscapeSequence* | yes | -- |
| 3.10.4 | "`'`*`.*LineTerminator.*`*`'`" | yes | yes through parser |
| 3.10.5 | "`"`*`.*LineTerminator.*`*`"`" | yes | yes through parser |
| 3.10.5 | "`"`*`.*LineTerminator.*`*`"`" | yes | yes through parser |
| 3.10.6 | `\X` with `X != b,t,n,f,r,",',\,0,1,2,3,4,5,6,7` | yes | yes through parser |
| 4.3 | `T.id` whitout `id` being an accessible member type of `T` | yes | -- |
| 4.4 | see section | -- | -- |
| 4.4 | see section (`erasures`) | -- | -- |
| 4.8 | type member of parameterized type as raw type | -- | -- |
| 4.8 | "pass actual type parameters to a non-static type member of a raw type that is not inherited from its superclasses or superinterfaces." | -- | -- |
| 4.9 | see section "Intersection Types" | -- | -- |
| 5.1.10 | see section "Capture Conversions" | -- | -- |
| 5.2 | see section "Assignment Conversions" | yes | -- |
| 5.5 | Casting conversions error cases | no | no |
| 6.4.3 | referring to any of the class fields by its simple name if there are two or more fields with the same simple name | yes | -- |
| 6.4.4 | Interface case | no | no |
| 6.5.2 | for *AmbiguousName* as *`name.Identifier`*, if `name` is reclassified as a `TypeName` and *Identifier* is neither a method or field **nor** a member type of the type denoted by `TypeName` | yes | -- |
| 6.5.2 | for *AmbiguousName* as *`name.Identifier`*, if `name` is reclassified as a *ExpressionName* and *Identifier* is neither a method or field **nor** a member type of the type denoted by `T` with `T` the type of the expression denoted by *ExpressionName* | yes | -- |
| 6.5.3 | if a package name consists of a single *Identifier* and no top level package of that name is in scope | yes | -- |
| 6.5.5.2 | if a type name is of the form `Q.Id`, If `Id` does not name a member type within `Q`, or the member type named `Id` within `Q` is not accessible, or `Id` names more than one member type within `Q` | yes | -- |
| 6.5.6.1 | if an expression name consists of a single *Identifier* and there is not exactly one visible declaration denoting either a local variable, parameter or field in scope at the point at which the the Identifier occurs | yes | -- |
| 6.5.6.1 | if the field is an instance variable and it appears within a static method, static initializer, or initializer for a static variable | yes | -- |
| 6.5.6.2 | if an expression name is of the form `Q.Id` and `Q` is a package name | yes | -- |
| 6.5.6.2 | if an expression name is of the form `Q.Id`, `Q` is a type name that names a class type and there is not exactly one accessible member of the class type that is a field named `Id` | yes | -- |
| 6.5.6.2 | if an expression name is of the form `Q.Id`, `Q` is a type name that names a class type, there is exactly one accessible member of the class type that is a field named `Id` and this field is not declared `static` | yes | -- |
| 6.5.6.2 | if an expression name is of the form `Q.Id`, `Q` is a type name that names a interface type...  | no | no |
| 6.5.6.2 | if an expression name is of the form `Q.Id`, `Q` is an expression name, `T` the type of `Q` and `T` is not a reference type | yes | -- |
| 6.5.6.2 | if an expression name is of the form `Q.Id`, `Q` is an expression name, `T` the type of `Q` and there is not exactly one accessible member of the type `T` that is a field named `Id` | yes | -- |
| 6.5.6.2 | if an expression name is of the form `Q.Id`, `Q` is an expression name, `T` the type of `Q`, there is exactly one accessible member of the type `T` that is a field named `Id`, this field is either field of interface type, `final` field of a class type or the `final` field `length` of an array type, and `Q.Id` appears in a context that requires a variable and not a value  | yes | -- |
| 6.5.7.1 | the *Identifier* in an *ElementValuePair* is not the simple name of one of the elements of the annotation type identified by *TypeName* in the containing annotation | no | no |
| 6.5.7.2 | if a method name is of the form `Q.Id` and `Q` is a package name | yes | -- |
| 7.4 | if an annotation `a` on a package declaration corresponds to an annotation type `T`, `T` has a (meta-)annotation `m` that corresponds to `annotation.Target` and `m` does not have an element whose value is `annotation.ElementType.PACKAGE` | no | no |
| 7.5.1 | `import` *`TypeName`* if *TypeName* does **not** exist | yes | -- |
| 7.5.1 | `import` *`TypeName`* if the named type is **not** accessible | yes | -- |
| 7.5.1 | if two single-type-import declarations in the same compilation unit attempt to import types with the same simple name | yes | -- |
| 7.5.1 | if a compilation unit contains both a single-static-import declaration that imports a type whose simple name is `n`, and a single-type-import declaration  that imports a type whose simple name is `n` | yes | -- |
| 7.5.1 | if another top level type with the same simple name is declared in the current compilation unit except by a type-import-on-demand declaration or a static-import-on-demand declaration | yes | -- |
| 7.5.2 | `import` *`PackageOrTypeName`*`.*` if *PackageOrTypeName* is not accessible | yes | -- |
| 7.5.3 | `import static` *`TypeName`* `.` *`Identifier`* if *TypeName* does not exist | yes | -- |
| 7.5.3 | `import static` *`TypeName`* `.` *`Identifier`* if there is no member of the name *Identifier* or if all of the named members are not accessible | yes | -- |
| 7.5.3 | if a compilation unit contains both a single-static-import declaration that imports a type whose simple name is `n`, and a single-type-import declaration that imports a type whose simple name is `n` | yes | -- |
| 7.5.3 | if a single-static-import declaration imports a type whose simple name is `n`, and the compilation unit also declares a top level type whose simple name is `n` | yes | -- |
| 7.5.4 | `import static` *`TypeName`* `.*` if *TypeName* does **not** exist | yes | -- |
| 7.5.4 | `import static` *`TypeName`* `.*` if the named type is **not** accessible | yes | -- |
| 7.6 | if the name of a top level type appears as the name of any other top level class or interface type declared in the same package | yes | -- |
| 7.6 | if the name of a top level type is also declared as a type by a single-type-import declaration in the compilation unit containing the type declaration | yes | -- |
| 7.6 | if a top level type declaration contains any one of the following access modifiers: `protected`, `private` or `static` | yes | -- |
| 8.1 | if a class has the same simple name as any of its enclosing classes or interfaces | yes | yes |
| 8.1.1 | if the same modifier appears more than once in a class declaration | yes | yes |
| 8.1.1 | if an annotation `a` on a class declaration corresponds to an annotation type `T`, `T` has a (meta-)annotation `m` that corresponds to `annotation.Target`, and `m` does not have an element whose value is `annotation.ElementType.TYPE` | no | no |
| 8.1.1.1 | if a normal class that is not abstract contains an abstract method | yes | yes |
| 8.1.1.1 | Enum types declared `abstract` | no | no |
| 8.1.1.1 | if an enum type `E` has an abstract method `m` as a member whithout having one or more enum constants that have class bodies that provide concrete implementations of `m` | no | no |
| 8.1.1.1 | the class body of an enum constant declares an abstract method. | no | no |
| 8.1.1.1 | `new myClass` with `myClass` declared as `abstract` | yes | -- |
| 8.1.1.1 |  declaration of an abstract class type such that it is not possible to create a subclass that implements all of its abstract methods | -- | -- |
| 8.1.1.2 | if the name of a final class appears in the extends clause of another class declaration | yes | -- |
| 8.1.1.2 | class is declared both `final` and `abstract` | yes | yes |
| 8.1.2 |  if a generic class is a direct or indirect subclass of `Throwable` | yes | -- |
| 8.1.2 |  referring to a type parameter of a class `C` anywhere in the declaration of a static member of `C` or the declaration of a static member of any type declaration nested within `C` | no | no |
| 8.1.2 |  referring to a type parameter of a class `C` within a static initializer of `C` or any class nested within `C` | no | no |
| 8.1.4 | `extends` *`ClassType`* if *ClassType* is not accessible | yes | -- |
| 8.1.4 | `extends` *`ClassType`* if *ClassType* names a final class | yes | -- |
| 8.1.4 | `extends` *`ClassType`* if *ClassType* names the class `Enum` or any invocation of it | no | no |
| 8.1.4 | `extends` *`TypeName<TypeArgs>`* and it is not a correct invocation of the type declaration denoted by *TypeName*, or some of the type arguments are wildcard type arguments | no | no |
| 8.1.4 | if a class depends on itself : <br> `class A extends B {}` <br> `class B extends A {}` | yes | -- |
| 8.1.5 | Interfaces related error cases | no | no |
| 8.2 | Error cases because only members of a class that are declared ``protected`` or ``public`` are inherited by subclasses declared in a package other than the one in which the class is declared | -- | -- |
| 8.3 | the body of a class declaration declares two fields with the same name | yes | yes |
| 8.3.1 | the same modifier appears more than once in a field declaration | yes | yes |
| 8.3.1 | a field declaration has more than one of the access modifiers `public`, `protected`, and `private` | yes | yes |
| 8.3.1 | if an annotation `a` on a field declaration corresponds to an annotation type `T`, `T` has a (meta-)annotation `m` that corresponds to `annotation.Target`, and `m` does not have an element whose value is `annotation.ElementType.FIELD` | no | no |
| 8.3.1.2 | a blank `final` class variable is not definitely assigned by a static initializer of the class in which it is declared | yes | -- |
| 8.3.1.2 | a blank `final` instance variable is not definitely assigned at the end of every constructor of the class in which it is declared | yes | -- |
| 8.3.1.4 | a `final` variable is also declared `volatile` | yes | -- |
| 8.3.2 | the evaluation of a variable initializer for a static field of a named class (or of an interface) can complete abruptly with a checked exception | -- | -- |
| 8.3.2 | if an instance variable initializer of a named class can throw a checked exception (unless that exception or one of its supertypes is explicitly declared in the throws clause of each constructor of its class and the class has at least one explicitly declared constructor) | -- | -- |
| 8.3.2.1 | if a reference by simple name to any instance variable occurs in an initialization expression for a class variable | yes | -- |
| 8.3.2.1 | if the keyword `this` or the keyword `super` occurs in an initialization expression for a class variable | yes | -- |
| 8.3.2.3 | see *Restrictions on the use of Fields during Initialization* | yes | -- |
| 8.3.3.3 | referring to any ambiguously inherited field by its simple name | yes | -- |
| 8.4 | the body of a class declares as members two methods with override-equivalent signatures (name, number of parameters, and types of any parameters) | yes | yes |
| 8.4.1 | two formal parameters of the same method or constructor are declared to have the same name <br> Example: `void myMethod(int i, float i)` | yes | yes |
| 8.4.1 | if an annotation `a` on a formal parameter corresponds to an annotation type `T`, `T` has a (meta-)annotation `m` that corresponds to `annotation.Target`, and `m` does not have an element whose value is `annotation.ElementType.PARAMETER` | no | no |
| 8.4.1 | if a method or constructor parameter that is declared `final` is assigned to within the body of the method or constructor | yes | -- |
| 8.4.2 | declare two methods with override-equivalent signatures (defined below) in a class | yes | yes |
| 8.4.3 | the same modifier appears more than once in a method declaration | yes | yes |
| 8.4.3 | a method declaration has more than one of the access modifiers `public`, `protected`, and `private` | yes | yes |
| 8.4.3 | a method declaration that contains the keyword `abstract` also contains any one of the keywords `private`, `static`, `final`, `native`, `strictfp`, or `synchronized` | yes | yes |
| 8.4.3 | a method declaration that contains the keyword `native` also contains `strictfp` | yes | yes |
| 8.4.3 | if an annotation `a` on a method declaration corresponds to an annotation type `T`, `T` has a (meta-)annotation `m` that corresponds to `annotation.Target`, and `m` does not have an element whose value is `annotation.ElementType.METHOD` | no | no |
| 8.4.3.1 | an abstract method `m` is not declared directly within an abstract class `A` | yes | -- |
| 8.4.3.1 | a subclass of `A` that is not abstract does not provide an implementation for `m` | yes | -- |
| 8.4.3.2 | attempt to reference the current object using the keyword `this` or the keyword `super` or to reference the type parameters of any surrounding declaration in the body of a class method | yes | -- |
| 8.4.3.3 | attempt to override or hide a final method | yes | -- |
| 8.4.6 | if any *ExceptionType* mentioned in a `throws` clause is not a subtype of `Throwable` | yes | -- |
| 8.4.6 | for each checked exception that can result from execution of the body of a method or constructor, if that exception type and a supertype of that exception type is **not** mentioned in a `throws` clause in the declaration of the method or constructor | yes | -- |
| 8.4.6 | if `B` is a class or interface, and `A` is a superclass or superinterface of `B`, and a method declaration `n` in `B` overrides or hides a method declaration `m` in `A`, `n` has a `throws` clause that mentions any checked exception types, and `m` does not have have a `throws` clause | -- | -- |
| 8.4.6 | if `B` is a class or interface, and `A` is a superclass or superinterface of `B`, and a method declaration `n` in `B` overrides or hides a method declaration `m` in `A`, `n` has a `throws` clause that mentions any checked exception types, `m` has a `throws` clause and for some checked exception type listed in the throws clause of `n` , that same exception class or one of its supertypes is not in the erasure of the `throws` clause of `m` | -- | -- |
| 8.4.7 | a method declaration is either `abstract` or `native` and has a block for its body | yes | yes |
| 8.4.7 | a method declaration is neither `abstract` nor `native` and has a semicolon for its body | yes | yes |
| 8.4.7 | a `void` method contains a `return` statement that has an *Expression* | yes | yes |
| 8.4.7 | if a method has a return type, the body of the method does not contain `return` statements or some `return` statements do not have an *Expression* | yes | yes |
| 8.4.8.1 | an instance method overrides a `static` method | -- | -- |
| 8.4.8.2 | a `static` method hides an instance method | -- | -- |
| 8.4.8.3 | if a method declaration `d1` with return type `R1` overrides or hides the declaration of another method `d2` with return type `R2` and `d1` is not return-type substitutable for `d2` | -- | -- |
| 8.4.8.3 | a method declaration has a `throws` clause that conflicts with that of any method that it overrides or hides | -- | -- |
| 8.4.8.3 | if an overridden or hidden method is `public` and the overriding or hiding method is **not** `public` | yes | -- |
| 8.4.8.3 | if an overridden or hidden method is `protected` and the overriding or hiding method is **not** `protected` or `public` | yes | -- |
| 8.4.8.3 | if the overridden or hidden method has default (package) access and the overriding or hiding method is `private` | yes | -- |
| ... | ... | ... | ... |
| 8.9 | Enum error cases | no | no |
| 9 | Interfaces error cases | no | no |
| 10.4 | attempt to access an array component with a `long` index value results | yes | -- |
| 10.6 | some expressions are not assignment-compatible with the array’s component type | yes | -- |
| 10.6 | if the component type of the array being initialized is not reifiable | -- | -- |
| 11.2.3 | if a method or constructor body can throw some exception type `E` when both of the following hold: <br> • `E` is a checked exception type <br>• `E` is not a subtype of some type declared in the throws clause of the method or constructor | -- | -- |
| 11.3 | if a static initializer or class variable initializer within a named class or interface can throw a checked exception type | -- | -- |
| 11.3 | if an instance variable initializer of a named class can throw a checked exception unless that exception or one of its supertypes is explicitly declared in the throws clause of each constructor of its class and the class has at least one explicitly declared constructor | -- | -- |
| 11.3 | if a `catch` clause catches checked exception type `E1` but there exists no checked exception type `E2` such that all of the following hold: <br> • `E2` <: `E1` <br> • The `try` block corresponding to the `catch` clause can throw `E2` <br> • No preceding catch block of the immediately enclosing `try` statement catches `E2` or a supertype of `E2`. <br> **unless** `E1` is the class Exception. | -- | -- |
| ... | ... | ... | ... |
| 14.21 | a statement is unreachable | -- | -- |
| 15.8.3 | the keyword `this` appears elsewhere than in the body of an instance method, instance initializer or constructor, or in the initializer of an instance variable of a class | yes | -- |
| 15.8.4 | `ClassName.this` whith the current class not an inner class of class `ClassName` or `ClassName` itself | yes | -- |
| 15.9 | any of the type arguments used in a class instance creation expression are wildcard type arguments | yes | -- |
| 15.9.1 | for `new TypeArgumentsopt ClassOrInterfaceType` the class or interface named by *ClassOrInterfaceType* is not accessible or if *ClassOrInterfaceType* is an enum type | yes | -- |
| 15.9.1 | for `new TypeArgumentsopt ClassOrInterfaceType` the class or interface named by *ClassOrInterfaceType* is `final` | yes | -- |
| 15.9.1 | for `Primary. new TypeArgumentsopt Identifier` if *Identifier* is not the simple name of an accessible non-`final` inner class that is a member of the compile-time type of the *Primary* | -- | -- |
| 15.9.1 | for `Primary. new TypeArgumentsopt Identifier` if *Identifier* is ambiguous or denotes an enum type | -- | -- |
| 15.9.1 | for `Primary. new TypeArgumentsopt Identifier` if *Identifier* is not the simple name of an accessible non-`abstract` inner class that is a member of the compile-time type of the *Primary* | -- | -- |
| 15.9.1 | for `Primary. new TypeArgumentsopt Identifier` if *Identifier* is ambiguous or denotes an enum type | -- | -- |
| 15.9.2 |  TO COMPLETE : Enclosing Instances error cases | -- | -- |
| 15.10 | *ClassOrInterfaceType* does not denote a reifiable type | -- | -- |
| 15.10 | the type of each dimension expression within a *DimExpr* is not a type that is convertible to an integral type | yes | -- |
| 15.10 | the promoted type is not `int` | yes | -- |
| 15.11.1 | for a *FieldAccess* `Primary.Identifier`, the type of the *Primary* is not a reference type `T` | yes | -- |
| 15.11.1 | for a *FieldAccess* `Primary.Identifier`, the identifier names several accessible member fields of type `T` | yes | -- |
| 15.11.1 | for a *FieldAccess* `Primary.Identifier`, the identifier does not name an accessible member field of type `T` | yes | -- |
| 15.11.2 |  if `super` appears in class `Object` | -- | -- |
| 15.11.2 | `T.super` if the current class is not an inner class of class `T` or `T` itself | yes | -- |
| 15.12.1 | if the form is *MethodName* that is `TypeName.Identifier` and *TypeName* is the name of an interface | no | no |
| 15.12.1 | if the form is `super.NonWildTypeArgumentsopt Identifier` and  `T` the type declaration immediately enclosing is either the class `Object` or an interface | yes | -- |
| 15.12.1 | if the form is `ClassName.super.NonWildTypeArgumentsopt Identifier`and `ClassName` is not a lexically enclosing class of the current class | yes | -- |
| 15.12.1 | if the form is `ClassName.super.NonWildTypeArgumentsopt Identifier`and `ClassName` is the class Object | yes | -- |
| 15.12.1 | if the form is `ClassName.super.NonWildTypeArgumentsopt Identifier` and  `T` the type declaration immediately enclosing is either the class `Object` or an interface | yes | -- |
| 15.12.1 | if the form is `TypeName.NonWildTypeArguments Identifier` and *TypeName* is the name of an interface rather than a class | no | no |
| 15.12.2.2 | if the search does not yield at least one method that is potentially applicable | -- | -- |
| 15.12.2.4 | if no applicable variable arity method is found | -- | -- |
| 15.12.3 | if the method invocation has a *MethodName* of the form *Identifier*, and the method is an instance method and the invocation appears within a static context | -- | -- |
| 15.12.3 | if the method invocation has a *MethodName* of the form *Identifier*, and the method is an instance method and the invocation does not appear within a static context and the invocation is not directly enclosed by `ClassName` or an inner class of `ClassName` | -- | -- |
| 15.12.3 | if the method invocation has a *MethodName* of the form *`TypeName.Identifier`* or *`TypeName.NonWildTypeArguments Identifier`* and the compile-time declaration for the method invocation is for an instance method | -- | -- |
| 15.12.3 | if the method invocation has the form `super.NonWildTypeArgumentsopt Identifier` and the method is `abstract` | yes | -- |
| 15.12.3 | if the method invocation has the form `super.NonWildTypeArgumentsopt Identifier` and the method invocation occurs in a static context | -- | -- |
| 15.12.3 | if the method invocation has the form `ClassName.super.NonWildTypeArgumentsopt Identifier` and the method is `abstract` | yes | -- |
| 15.12.3 | if the method invocation has the form `ClassName.super.NonWildTypeArgumentsopt Identifier` and the method invocation occurs in a static context | -- | -- |
| 15.12.3 | if the method invocation has the form `ClassName.super.NonWildTypeArgumentsopt Identifier` and the invocation is not directly enclosed by `ClassName` or an inner class of `ClassName` | -- | -- |
| 15.12.3 | the compile-time declaration for the method invocation is `void`, and the method invocation is **not** a top-level expression ( the *Expression* in an expression statement or in the *ForInit* or *ForUpdate* part of a for statement ) | yes | -- |
| 15.12.4.1 | for a *MethodInvocation*, if the *MethodName* is an *Identifier*, the invocation mode is not `static`, given T be the enclosing type declaration of which the method is a member, and n an integer such that T is the *nth* lexically enclosing type declaration of the class whose declaration immediately contains the method invocation, the nth lexically enclosing instance of `this` does **not** exist. | -- | -- |
| 15.13 | *`ArrayRefExp`*`[exp]` the type of the *ArrayRefExp* is not an array type | yes | -- |
| 15.14.2 | in `exp++` result of `exp` is not a variable of a type that is convertible to a numeric type | yes | -- |
| 15.14.3 | in `exp--` result of `exp` is not a variable of a type that is convertible to a numeric type | yes | -- |
| 15.15.1 | in `++exp` result of `exp` is not a variable of a type that is convertible to a numeric type | yes | -- |
| 15.15.2 | in `--exp` result of `exp` is not a variable of a type that is convertible to a numeric type | yes | -- |
| 15.15.3 | the type of the operand expression of the unary `+` operator is not a type that is convertible to a primitive numeric type | yes | -- |
| 15.15.4 | the type of the operand expression of the unary `-` operator is not a type that is convertible to a primitive numeric type | yes | -- |
| 15.15.5 | the type of the operand expression of the unary `~` operator is not a type that is convertible to a primitive integral type | yes | -- |
| 15.15.6 | the type of the operand expression of the unary `!` operator is neither `boolean` nor `Boolean` | yes | -- |
| 15.16 | Cast expressions error cases | no | no |
| 15.17 | the type of each of the operands of a multiplicative operator is not a type that is convertible to a primitive numeric type | yes | -- |
| 15.18 | for `a+b` with `a` and `b` not Strings, the type of each of the operands of the `+` operator is not a type that is convertible to a primitive numeric type | yes | -- |
| 15.18 | the type of each of the operands of the binary `-` operator is not a type that is convertible to a primitive numeric type | yes | -- |
| 15.19 | the type of each of the operands of a shift operator must be a type that is convertible to a primitive integral type | yes | -- |
| 15.20 | `a<b<c` | yes | -- |
| 15.20.1 | the type of each of the operands of a numerical comparison operator is not a type that is convertible to a primitive numeric type | yes | -- |
| 15.20.2 | the type of a *RelationalExpression* operand of the instanceof operator is neither a reference type nor the null type | yes | -- |
| 15.20.2 | the *ReferenceType* mentioned after the instanceof operator does not denote a reference type | yes | -- |
| 15.20.2 | the *ReferenceType* mentioned after the instanceof operator does not denote a reifiable type | -- | -- |
| 15.21 | `a==b==c` where c is **not** of type `boolean` | yes | -- |
| 15.21 | `a == b`, `a != b` if `a` and `b` **not** convertible to numeric type, **not** `boolean` or `Boolean`, **not** reference type or null | yes | -- |
| 15.21.3 | `a == b`, `a != b` if it is impossible to convert type of either operand to the type of the other by a casting conversion | yes | -- |
| 15.22 | `ex1 & ex2`, `ex1 ^ ex2`, `ex1 | ex2` where both `ex1` and `ex2` types are neither `boolean` nor numeric type | yes | -- |
| 15.23 | `ex1 && ex2` where `ex1` or `ex2` type is neither `boolean` nor `Boolean` | yes | -- |
| 15.24 | `ex1 || ex2` where `ex1` or `ex2` type is neither `boolean` nor `Boolean` | yes | -- |
| 15.25 | `ex ? ex1 : ex2` where `ex` type is neither `boolean` nor `Boolean` | yes | -- |
| 15.25 | `ex ? ex1 : ex2` where `ex1` or `ex2` are `void` method invocations | yes | -- |
| 15.26 | `a = b` where `a` is not a variable | yes | -- |
| 15.26.1 | `a = b` where `b` cannot be converted to `a` type by assignment conversion | yes | -- |
| 16 | local variable and blank final field must be *definitely assigned* before access | yes | -- |
| 16 | blank final variable must be *definitely unassigned* before assignment | yes | -- |
| 16.1.8 | local variable `v` must be *definitely assigned* before compound assignment (example: `a += b`) where `a` is `v` | yes | -- |
