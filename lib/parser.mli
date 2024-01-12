open Picture

type operation
type stack
type token
type state

val apply : operation -> state -> state
val push : float -> state -> state
val parse_token : string -> token 
val process_token : token -> state -> state
val process_tokens : token list -> state
val process_string_tokens : string list -> float list
val get_stack : state -> float list
val get_current_picture : state -> Picture.picture

(* TODO: just for debugging *)
val token_to_string : token -> string

