open Picture

type arithmetic_operation = 
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

let apply op state =
    match op with
    | Arithmetic_op Add -> 
        let stack = state.stack in
        let new_stack = (List.hd stack) +. (List.hd (List.tl stack)) :: (List.tl (List.tl stack)) in
        { state with stack = new_stack }
    | Arithmetic_op Sub -> 
        let stack = state.stack in
        let new_stack = (List.hd stack) -. (List.hd (List.tl stack)) :: (List.tl (List.tl stack)) in
        { state with stack = new_stack }
    | Arithmetic_op Mul -> 
        let stack = state.stack in
        let new_stack = (List.hd stack) *. (List.hd (List.tl stack)) :: (List.tl (List.tl stack)) in
        { state with stack = new_stack }
    | Arithmetic_op Div -> 
        let stack = state.stack in
        let new_stack = (List.hd stack) /. (List.hd (List.tl stack)) :: (List.tl (List.tl stack)) in
        { state with stack = new_stack }
    | Move_to -> 
        let stack = state.stack in
        let new_stack = List.tl stack in
        let new_point = match state.stack with
            | x :: y :: _ -> Some (Picture.make_point x y)
            | _ -> None
        in
        { state with stack = new_stack; current_point = new_point }
    | Line_to ->
        let stack = state.stack in
        let new_stack = List.tl stack in
        let new_path = match state.current_point with
            | Some point -> point :: state.current_path
            | None -> state.current_path
        in
        let new_point = match state.stack with
            | x :: y :: _ -> Some (Picture.make_point x y)
            | _ -> None
        in
        { state with stack = new_stack; current_point = new_point; current_path = new_path }
    | Close_path ->
        let stack = state.stack in
        let new_stack = List.tl stack in
        let new_path = match state.current_point with
            | Some point -> point :: state.current_path
            | None -> state.current_path
        in
        { state with stack = new_stack; current_point = None; current_path = new_path }

let push elem stack = { stack with stack = elem :: stack.stack }

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


let process_tokens tokens =
    let rec process_tokens_rec tokens stack =
        match tokens with
        | [] -> stack
        | token :: rest -> process_tokens_rec rest (process_token token stack)
    in
    process_tokens_rec tokens current_state

let get_stack state = state.stack

let process_string_tokens string_tokens =
    let tokens = List.map parse_token string_tokens in
    get_stack (process_tokens tokens)

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

