val filename : string option ref
val scale : int ref
val display : bool ref

val speclist : (Arg.key * Arg.spec * Arg.doc) list
val usage_msg : string

val read_input : unit -> string
