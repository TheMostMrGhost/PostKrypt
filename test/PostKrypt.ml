open Lib
open Lib.Picture

let readPic input_string =
  let tokens = String.split_on_char ' ' input_string in
  List.map Lexer.parse_token tokens

let () =
(*     assert (List.length (Lib.Lexer.get_stack (Lib.Lexer.process_tokens ( readPic "0 7 9 add div"))) > 0); *)
(*     (* Addition tests *) *)
(*     print_float_list (Lib.Lexer.get_stack (Lib.Lexer.process_tokens ( readPic "2 0 7 9 add"))); *)
(*     (* NOTE: readPic reverses order. Input 2 0 7 9 results in list [9; 7; 0; 2] *) *)
(*     assert (Lib.Lexer.get_stack (Lib.Lexer.process_tokens ( readPic "2 0 7 9 add")) = [16.; 0.; 2.]); *)
(*  *)
(* print_endline (Picture.string_of_pic (Lib.Picture.Picture.point_to_pic (Lib.Lexer.get_current_point *)
(*     (Lib.Lexer.process_tokens (readPic "2 0 moveto"))))); *)
(*  *)
(* print_endline (Picture.string_of_pic (Lib.Picture.Picture.point_to_pic (Lib.Lexer.get_current_point *)
(*     (Lib.Lexer.process_tokens (readPic "2 0 moveto 7 -2 moveto"))))); *)
(*  *)
(* print_endline (Picture.string_of_pic (Lib.Picture.Picture.point_to_pic (Lib.Lexer.get_current_point *)
(*     (Lib.Lexer.process_tokens (readPic "2 0 moveto 7 -2 lineto"))))); *)
(*  *)
(* print_endline (Picture.string_of_pic (Lib.Picture.Picture.point_to_pic (Lib.Lexer.get_current_point *)
(*     (Lib.Lexer.process_tokens (readPic "2 0 moveto 7 -2 lineto 4 4 lineto -12 10 lineto 2 5 6 3 1 36 73 -2 5 3 moveto lineto moveto closepath"))))); *)
(*  *)
(*     (* FIXME: Parsing error *) *)
(* print_endline (Picture.string_of_picture (Lib.Lexer.get_current_picture *)
(*     (Lib.Lexer.process_tokens (readPic "2 0 moveto 7 -2 lineto 4 4 lineto -12 10 lineto closepath")))); *)

print_endline (Picture.picture_to_postscript (Lib.Lexer.get_current_picture
        (Lib.Lexer.process_tokens (readPic "2 0 moveto 7 -2 lineto 4 4 lineto -12 10 lineto closepath"))));
(* print_endline (Picture.string_of_pic (Lib.Lexer.get_current_point *)
(*     (Lib.Lexer.process_tokens (readPic "closepath lineto 10 -12 lineto 4 4 lineto -2 7 moveto 0 2")))); *)
            
  (* print_endline "All tests passed" *)
