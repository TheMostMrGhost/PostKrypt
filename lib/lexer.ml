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

type stack_elem = 
    | Number of float
    | Operator of arithmetic_operation

type stack = stack_elem list

type state = {
    stack : stack;
    current_point : Picture.point;
    current_picture : Picture.picture;
}

let current_point = Picture.make_point 0.0 0.0

let apply op stack = 
    match stack with
    | Number x :: Number y :: stack' -> 
        let result = 
            match op with
            | Add -> x +. y
            | Sub -> x -. y
            | Mul -> x *. y
            | Div -> if y = 0.0 then failwith "Division by zero" else x /. y
        in
        Number result :: stack'
    | _ -> failwith "Invalid stack"

let parse_token token =
    match token with
    | "add" -> Operator Add
    | "sub" -> Operator Sub
    | "mul" -> Operator Mul
    | "div" -> Operator Div
    | _ -> Number (float_of_string token)

let push elem stack = elem :: stack
