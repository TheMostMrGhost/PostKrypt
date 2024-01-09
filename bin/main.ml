open Lib.Inputpic
open Lib.Picture
open Str

let parse_string_to_tokens input =
  let words = Str.split (regexp "[ \t\n\r]+") input in
  List.map Lib.Lexer.parse_token (List.filter (fun s -> s <> "") words)

let () =
  Arg.parse speclist (fun _ -> ()) usage_msg;
  let input_data, scale = readPic () in
  print_endline (Picture.picture_to_postscript scale (Lib.Lexer.get_current_picture
          (Lib.Lexer.process_tokens (parse_string_to_tokens input_data))));
