open Lib
open Lib.Lexer
open Lib.Inputpic
open Lib.Picture
open Str

let parse_string input =
  let words = Str.split (regexp "[ \t\n\r]+") input in
  List.filter (fun s -> s <> "") words

let parse_string_to_tokens input =
  let words = Str.split (regexp "[ \t\n\r]+") input in
  List.map Lib.Lexer.parse_token (List.filter (fun s -> s <> "") words)

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

let readPic input_string =
  let tokens = String.split_on_char ' ' input_string in
  List.map Lexer.parse_token tokens

let print_float_list float_list =
  List.iter (fun x -> Printf.printf "%f\n" x) float_list

(* let () = *)
(*   let words = Lib.Inputpic.readPic () in *)
(*     (* Print this: Lib.Lexer.process_tokens words; *) *)
(*     let state = Lib.Lexer.process_tokens words in *)
(*     process_and_print_stack_float (Lib.Lexer.get_stack state); *)

(* let () = print_endline (Picture.picture_to_postscript (Lib.Lexer.get_current_picture *)
(*         (Lib.Lexer.process_tokens (readPic "0 0 moveto 100 0 lineto 100 0 moveto 100 100 lineto 200 200 moveto 250 250 lineto")))); *)

(* let () = print_endline (Picture.picture_to_postscript (Lib.Lexer.get_current_picture *)
(*         (Lib.Lexer.process_tokens (readPic "0 0 moveto 0 100 lineto 0 100 moveto 100 100 lineto 200 200 moveto 250 250 lineto closepath")))); *)


(* let () = print_float_list (Lib.Lexer.get_stack (Lib.Lexer.process_tokens ( readPic "7 0 9 add div"))); *)

(* Read ingput file using inputpic module *)

let process_input_data input_data =
  (* Define your logic to process the input data here *)
  (* For demonstration, just printing the input data *)
    print_endline input_data

let () =
  (* Parse command line arguments *)
  Arg.parse speclist (fun _ -> ()) usage_msg;

  (* Read input from the specified source *)
  let input_data = read_input () in

  (* Process the input data *)
  print_endline (Picture.picture_to_postscript (Lib.Lexer.get_current_picture
          (Lib.Lexer.process_tokens (parse_string_to_tokens input_data))));

    (* process_input_data input_data; *)

  (* Print the output *)

  (* Add additional logic as needed *)



(* let () = *)
(*   Arg.parse speclist (fun _ -> ()) usage_msg; *)
(*   let input_data = read_input () in *)
(*   List.iter print_endline (List.map Lib.Lexer.token_to_string (parse_string_to_tokens input_data)); *)
