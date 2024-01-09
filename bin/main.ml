open Lib.Inputpic
open Lib.Picture
open Str

let parse_string_to_tokens input =
  let words = Str.split (regexp "[ \t\n\r]+") input in
  List.map Lib.Lexer.parse_token (List.filter (fun s -> s <> "") words)

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
