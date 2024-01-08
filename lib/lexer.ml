open Picture

type arithmetic_operation = 
    | Empty
    | Add
    | Sub
    | Mul
    | Div

type operation =
    | Arithmetic_op of arithmetic_operation
    | Move_to
    | Line_to
    | Close_path

type stack = float list

type token =
    | Operation of operation
    | Number of float

type path = Picture.point list

type state = {
    stack : stack;
    current_point : Picture.point option;
    current_path : path;
    current_picture : Picture.picture;
}

let current_state = {
    stack = [];
    current_point = None;
    current_path = [];
    current_picture = Picture.empty;
}

let apply op stack =
    match op with
    | Arithmetic_op Add -> (match stack with
        | x :: y :: rest -> (x +. y) :: rest
        | _ -> failwith "Not enough elements on the stack")
    | Arithmetic_op Sub -> (match stack with
        | x :: y :: rest -> (x -. y) :: rest
        | _ -> failwith "Not enough elements on the stack")
    | Arithmetic_op Mul -> (match stack with
        | x :: y :: rest -> (x *. y) :: rest
        | _ -> failwith "Not enough elements on the stack")
    | Arithmetic_op Div -> (match stack with
        | x :: y :: rest -> (x /. y) :: rest
        | _ -> failwith "Not enough elements on the stack")
    | _ -> stack

let push elem stack = elem :: stack

let parse_token string_token =
    match string_token with
    | "add" -> Operation (Arithmetic_op Add)
    | "sub" -> Operation (Arithmetic_op Sub)
    | "mul" -> Operation (Arithmetic_op Mul)
    | "div" -> Operation (Arithmetic_op Div)
    | "moveto" -> Operation Move_to
    | "lineto" -> Operation Line_to
    | "closepath" -> Operation Close_path
    | _ -> Number (float_of_string string_token)

let process_token token stack =
    match token with
    | Operation op -> apply op stack
    | Number n -> push n stack

(* TODO: delete in an actual implementation *)
let token_to_string token =
    match token with
    | Operation (Arithmetic_op Add) ->  "add"
    | Operation (Arithmetic_op Sub) ->  "sub"
    | Operation (Arithmetic_op Mul) ->  "mul"
    | Operation (Arithmetic_op Div) ->  "div"
    | Operation Move_to ->  "moveto"
    | Operation Line_to ->  "lineto"
    | Operation Close_path ->  "closepath"
    | Number n ->  (string_of_float n)
    | _ ->  "Unknown token"
