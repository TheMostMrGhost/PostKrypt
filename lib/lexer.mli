type operation
type stack
type token

val apply : operation -> stack -> stack
val push : float -> stack -> stack
val parse_token : string -> token 
