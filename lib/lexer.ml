type operation = 
    | Add
    | Sub
    | Mul
    | Div

type seq_elem = 
    | Number of float
    | Operator of operation


type stack = seq_elem list

let apply op stack = 
    match stack with
    | Number x :: Number y :: stack' -> 
        let result = 
            match op with
            | Add -> x +. y
            | Sub -> x -. y
            | Mul -> x *. y
            | Div -> x /. y
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

