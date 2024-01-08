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

let parse_token token =
    match token with
    | "add" -> Arithmetic_op Add
    | "sub" -> Arithmetic_op Sub
    | "mul" -> Arithmetic_op Mul
    | "div" -> Arithmetic_op Div
    | _ -> Arithmetic_op Empty

let push elem stack = elem :: stack
