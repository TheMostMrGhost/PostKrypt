open Lib

let readPic input_string =
  let tokens = String.split_on_char ' ' input_string in
  List.map Lexer.parse_token tokens

let print_float_list float_list =
  List.iter (fun x -> Printf.printf "%f\n" x) float_list

let () =
    assert (List.length (Lib.Lexer.process_tokens ( readPic "0 7 9 add div")) > 0);
    (* Addition tests *)
    print_float_list (Lib.Lexer.process_tokens ( readPic "2 0 7 9 add"));
    (* NOTE: readPic reverses order. Input 2 0 7 9 results in list [9; 7; 0; 2] *)
    assert (Lib.Lexer.process_tokens ( readPic "2 0 7 9 add") = [16.; 0.; 2.]);
  print_endline "All tests passed"
