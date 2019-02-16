open Type

type javaclass = {
    extends: string option;
    (* TODO : implements: javainterface list; *)
    attributes: string javaattribute Hashtbl;
    methods: string javamethod Hashtbl;
    (* TODO : modifiers *)
    (* TODO : statics *)
}

type javaattribute = {
    javatype: t;
    (* TODO : modifiers *)
}

type javamethod ={
    return_type: t;
    body:
    attributes:
    (* TODO : modifiers *)
}

