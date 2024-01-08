type operation
type stack
type token

val apply : operation -> stack -> stack
val push : float -> stack -> stack
val parse_token : string -> token 
val process_token : token -> stack -> stack

(* TODO: just for debugging *)
val token_to_string : token -> string

