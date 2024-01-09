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
    | Rotate
    | Translate

type stack = float list

type token =
    | Operation of operation
    | Number of float

type path = {
    points : Picture.pic list;
    start_point : Picture.pic option;
}

type state = {
    stack : stack;
    current_point : Picture.point option;
    current_path : path;
    current_picture : Picture.picture;
}

let current_state = {
    stack = [];
    current_point = None;
    current_path = { points = []; start_point = None };
    current_picture = Picture.empty;
}

let add_path_to_picture path picture =
    let rec add_points_to_picture points picture =
        match points with
        | [] -> picture
        | Picture.Point p :: rest -> add_points_to_picture rest (Picture.add_to_picture (Point p) picture)
        | Picture.Vector v :: rest -> add_points_to_picture rest (Picture.add_to_picture (Vector v) picture)
        | Picture.Empty :: rest -> add_points_to_picture rest picture
    in
    match path.start_point with
    | Some start_point -> add_points_to_picture ( start_point :: path.points) picture
    | None -> add_points_to_picture path.points picture

let flush_path state =
    let new_picture = add_path_to_picture state.current_path state.current_picture in
    { state with
        stack = (match state.stack with | _::tl -> tl | [] -> []);
        current_path = {points = []; start_point = None}; 
        current_picture = Picture.(state.current_picture +++ new_picture)
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
        let new_stack = match List.hd (List.tl stack) with
            | 0.0 -> raise (Failure "Division by zero")
            | _ -> (List.hd stack) /. (List.hd (List.tl stack)) :: (List.tl (List.tl stack)) in
        { state with stack = new_stack }
    | Move_to -> 
        let x, y = match state.stack with
            | x :: y :: _ -> x, y
            | _ -> raise (Failure "Not enough elements in stack")
        in
        let new_point = Picture.make_point x y in
        { stack = List.tl (List.tl state.stack); 
            current_point = Some (new_point);  
            current_path = {points = []; start_point = Some (Picture.point_to_pic new_point)};
            current_picture =Picture.(state.current_picture +++ add_path_to_picture state.current_path state.current_picture)
        }
    | Line_to ->
        let x, y = match state.stack with
            | x :: y :: _ -> x, y
            | _ -> raise (Failure "Not enough elements in stack")
        in
        let new_point = Picture.make_point x y in
        let new_path = {
            state.current_path with 
            points = match state.current_point with
                | Some point -> Picture.vec_to_pic (Picture.make_vec point new_point) :: state.current_path.points  (* Append new point *)
                | None -> raise (Failure "No current point")
            (* points = (Vector  ):: state.current_path.points  (* Append new point *) *)
        } in
        { state with 
            stack = List.tl (List.tl state.stack); 
            current_path = new_path;
        }
    | Close_path ->
        flush_path state
    (* | Rotate -> { state with  *)
    (*     Transform.transform (Transform.rotate (List.hd state.stack)) *)
    (*     state.current_picture } *)
        | Rotate -> { state with 
            stack = List.tl state.stack;
            current_picture = Transform.transform (Transform.rotate (Picture.make_r (List.hd state.stack))) state.current_picture
        }


    | Translate -> state


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
    | "rotate" -> Operation Rotate
    | "translate" -> Operation Translate
    | _ -> Number (float_of_string string_token)

let process_token token stack =
    match token with
    | Operation op -> apply op stack
    | Number n -> push n stack


let process_tokens tokens =
    let rec process_tokens_rec tokens state =
        match tokens with
        | [] -> state
        | token :: rest -> process_tokens_rec rest (process_token token state)
    in
    flush_path (process_tokens_rec tokens current_state)

let get_stack state = state.stack
let get_point_or_default state =
    match state.current_point with
    | Some point -> point
    | None -> Picture.make_point 0.0 0.0  (* Default point at (0,0) *)

let get_current_point state = get_point_or_default state

let get_current_picture state = state.current_picture

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
    | Operation Rotate -> "rotate"
    | Operation Translate -> "translate"

