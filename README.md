The minijavac compiler.

A compilation project for Third year students of Telecom Bretagne.

'ocamlbuild Main.byte' (or native) to build the compiler. The main file
is Main/Main.ml, it should not be modified. It opens the given file,
creates a lexing buffer, initializes the location and call the compile
function of the module Main/compile.ml. It is this function that you
should modify to call your parser.

'ocamlbuild Main.byte -- <filename>' (or native) to build and then execute
the compiler on the file given. By default, the program searches for
file with the extension .java and append it to the given filename if
it does not end with it.

If you want to reuse an existing ocaml library. Start by installing it
with opam. For example, to use colored terminal output you
use 'opam install ANSITerminal'.
Then you must inform ocamlbuild to use the ocamlfind tool:
`ocamlbuild -use-ocamlfind Main.byte -- tests/UnFichierDeTest.java`
and you must modify your `_tags` file to declare the library:
true: package(ANSITerminal)

The Lexer/Parser is incomplete but should be ok for phase2. It
contains a remaining conflict: a conflict between expression and
declaration of variable in statements that could be solved at the
price of a much more complex grammar... Here the behavior of choosing
shift should be ok.


# TODO list

## Evaluation

### Primitives
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

### Class language
* [x] Class declaration
* [x] Method declaration
* [x] Attributes declaration
* [x] Attribute Access
* [x] Static Attribute declaration
* [x] Static Attribute Access
* [ ] Inheritance

### Control flow
* [x] If, else if, else
* [ ] Block
* [x] while loop
* [ ] For loop
* [x] Method call
* [x] Method return
* [ ] Method overload
* [ ] Inheritance

### Memory
* [x] Simple memory heap
* [x] Simple memory stack
* [ ] Unamed pointers
* [ ] Garbage collection

# Other
* [x] Inline printing
* [x] Inline memory dump
* [ ] Program arguments
* [ ] Simple STD
* [ ] Threads and multithreading control
* [ ] Imports


Parser errors
===
- b = true && true;
This doesn't respect operators precedence.
```
AST:
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

Excpected AST:
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

- ~~int notseenasanarray[]; this should be of type int[]. But int[] array; works~~ Fixed

```
AstAttribute
├─ Modifiers :
├─ notseenasanarray
├─ int
└─ none
```

- ~~two[] = one; This should not be parsed; The expression between [] should be mandatory~~ Fixed

- ~~one = two[]; Same as above~~ Fixed

- ~~emptyInit = new int[][1][]{1, 2}; This should not be parsed. Even the -v output is wrong ~~ Fixed by 88aa9f0265a5274cef0a1768755d673411428791
```
input:
arr = new int[2][][4]{3, 4};

-v output:
arr = {3,4}.int[2][][4];
```
