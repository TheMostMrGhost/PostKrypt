open Lib.Picture
open Lib.Lexer
let () = print_endline "Hello, World!"


let process_and_print_stack stack =
  let rec process_and_print_stack_helper stack =
    match stack with
    | [] -> ()
    | hd::tl -> print_endline (Lib.Lexer.token_to_string hd); process_and_print_stack_helper tl
  in
    process_and_print_stack_helper stack

let process_and_print_stack_float stack =
  let rec process_and_print_stack_helper stack =
    match stack with
    | [] -> ()
    | hd::tl -> print_endline (string_of_float hd); process_and_print_stack_helper tl
  in
    process_and_print_stack_helper stack


let () =
  let words = Lib.Inputpic.readPic () in
    (* Print this: Lib.Lexer.process_tokens words; *)
    let state = Lib.Lexer.process_tokens words in
    process_and_print_stack_float (Lib.Lexer.get_stack state);


