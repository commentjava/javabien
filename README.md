Minijava compiler Javabien
===========================


> The minijavac compiler.
> 
> A compilation project for Third year students of Telecom Bretagne.
> 
> 'ocamlbuild Main.byte' (or native) to build the compiler. The main file
> is Main/Main.ml, it should not be modified. It opens the given file,
> creates a lexing buffer, initializes the location and call the compile
> function of the module Main/compile.ml. It is this function that you
> should modify to call your parser.
> 
> 'ocamlbuild Main.byte -- <filename>' (or native) to build and then execute
> the compiler on the file given. By default, the program searches for
> file with the extension .java and append it to the given filename if
> it does not end with it.
> 
> If you want to reuse an existing ocaml library. Start by installing it
> with opam. For example, to use colored terminal output you
> use 'opam install ANSITerminal'.
> Then you must inform ocamlbuild to use the ocamlfind tool:
> `ocamlbuild -use-ocamlfind Main.byte -- tests/UnFichierDeTest.java`
> and you must modify your `_tags` file to declare the library:
> true: package(ANSITerminal)
> 
> The Lexer/Parser is incomplete but should be ok for phase2. It
> contains a remaining conflict: a conflict between expression and
> declaration of variable in statements that could be solved at the
> price of a much more complex grammar... Here the behavior of choosing
> shift should be ok.

------

## Quickstart

The project can be quickly built with the provided [Makefile](Makefile):

Build the Main binary:
```bash
make
```

Some toy programs are available under the `Test/programs/` folder they should
all run with the Javabien compiler, but not necessary with javac compiler.

```bash
Main.byte Test/programs/Stack.java
```

Run crafted test suite:
```bash
make test-all
```

To pin-point a specific problem, tests can be run individually, the list of
available tests receipes are available using the following command:
```bash
make test-list
```

## Design notes

### Memory management

#### Presentation

For each program the interpreter create a stack of memory which allow the the
java program to store and retreive variables. A memory is built around three
main structures:

- The `data_store`: This is an unstructured key-value map that associate an
  arbitrary key to a memory object. That object can be a Java object, a Java
  class, a Java variable, a method, a Java array... 
- The `reference_store`: this structure specify the association between a Java
  name (class name, object name...) with an identifier in the `data_store`.
  This structure define if a variable is in scope or not.
- The `names`: which is essentially a stack of `reference_stores`

Both strutures are built around an Ocaml Hashtbl, and the implementation is
done in a module details located in the in the
[Utils/Memory.ml](Utils/Memory.ml) file.

In order to define scopes for variables, the `names` is built as a stack of
`reference_stores`, when the program enters a new bloc, a new `reference_store`
is pushed on top of the stack and all new variables names will be referenced
there.

When searching for a name in scope, the function `Memory.get_address_from_name`
will look through each `reference_store` in the `names` stack starting from the
top. We call this `names` stack a transparent stack as it can be written only
on top but it can be peaked through.

In order to handle function call, we create another stack of `names` that is
opaque: only the top item can be written and read. In short the memory model
can be summarized using the following diagram:

![Program memory model](doc/memory_model.png)

The following diagram illustrate an example of memory binding:

![Program memory model example](doc/memory_model_example.png)


#### Garbage collection

The garbage collection is made by building a seen/not seen tree of objects with
the memory stacks as root. We iterate on each name in the stacked memories and
`reference_store`s and set an object as seen or not seen. Once this pass is
done each object in the `data_store` that is not marked as seen is deleted.

This method is slow and have a complexity around O(N) with N equal to the
number of objects in the datastore but is good enough for our use case.

The garbage collector is called at every block return, this heuristic can be
much more improved but we sticked with it.


#### Performance notices

This memory model has one main caveat : for each memory object retreived,
created or modified we need to make an indirection from the `names` store to
the `data_store`. This can lead to some penalities.

This is even worse for Arrays in which each element of an array is a reference
to an object in the `data_store`. In which case, iterating over an array
require to resolve each object which are not necessarily stored in continuous
parts of the memory.

### Natives and stdlib

When starting a program, the interpreter will load into memory an environement
of existing classes. Thoses classes are described in the  `stdlib/` folder.
They try to follow the jdk classes, but are nowhere as complete as the jdk.

In order to handle such classes we have implemented the Java method modifier:
`native`. When a `native` method is met, the interpreter will search in an
Hashtbl if the method is not referenced in Ocaml.

One example of Class with native methods is the `Debug` class which is used to
debug the interpreter. The static java method `Debug.dumpMemory()` will print the
state of the program memory in place. The static java method `Debug.debug(var)`
will print a java name as it is seen in  memory. Both methods can be used
anywhere in a program.

## TODO list

### AST evaluation

#### Primitives
* [ ] Primitives types
  * [x] int
  * [x] bool
  * [ ] float
  * [ ] Double
  * [ ] Char
  * [ ] String
* [x] Simple arithmetic operations
* [x] Simple logic operations
* [ ] Postfix operations
* [ ] Prefix operations
* [x] Variable declaration
* [x] Variable assignation (only `Assign`)
* [x] null element
* [ ] Arrays
  * [ ] Creation
  * [ ] Assignation
  * [ ] Element access
* [ ] Casting
* [ ] Exceptions
* [ ] Object unboxing

#### Class language
* [x] Class declaration
* [x] Method declaration
* [x] Attributes declaration
* [x] Attribute Access
* [x] Static Attribute declaration
* [x] Static Attribute Access
* [ ] Inheritance
* [ ] Native Method declaration

#### Control flow
* [x] If, else if, else
* [x] Block
* [x] while loop
* [ ] For loop
* [x] Method call
* [x] Method return
* [ ] Method overload
* [ ] Inheritance

#### Memory
* [x] Simple memory heap
* [x] Simple memory stack
* [ ] Unamed pointers
* [ ] Garbage collection

#### Other
* [x] Inline printing
* [x] Inline memory dump
* [ ] Program arguments
* [ ] Simple STD
* [ ] Threads and multithreading control
* [ ] Imports


## Parser errors

We have notice some errors in the builded AST, they are listed and sometime
fixed here:

- b = true && true; (also <= < > >=)
This doesn't respect operators precedence.
AST:
```
Expression
└─ Op
   ├─ Expression
   │  └─ AssignExp
   │     ├─ Expression
   │     │  └─ Name
   │     │     └─ b
   │     ├─ =
   │     └─ Expression
   │        └─ Val
   │           └─ Boolean
   │              └─ true
   ├─ &&
   └─ Expression
      └─ Val
         └─ Boolean
            └─ true
```

Expected AST:
```
Expression
└─ AssignExp
   ├─ Expression
   │  └─ Name
   │     └─ b
   ├─ =
   └─ Expression
      └─ Op
         ├─ Expression
         │  └─ Val
         │     └─ Boolean
         │        └─ true
         ├─ &&
         └─ Expression
            └─ Val
               └─ Boolean
                  └─ true
```

- ~~int notseenasanarray[]; this should be of type int[]. But int[] array; works~~ Fixed in 386aa089a259ed950709cd292c15254a9872b851

```
AstAttribute
├─ Modifiers :
├─ notseenasanarray
├─ int
└─ none
```

- ~~two[] = one; This should not be parsed; The expression between [] should be mandatory~~ Fixed in 386aa089a259ed950709cd292c15254a9872b851

- ~~one = two[]; Same as above~~ Fixed in 386aa089a259ed950709cd292c15254a9872b851

- ~~emptyInit = new int[][1][]{1, 2}; This should not be parsed. Even -v output is wrong~~ Fixed in 88aa9f0265a5274cef0a1768755d673411428791
```
input:
arr = new int[2][][4]{3, 4};

-v output:
arr = {3,4}.int[2][][4];
```

