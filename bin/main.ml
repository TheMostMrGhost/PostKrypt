open Lib.Inputpic
open Lib.Picture
open Str

let parse_string_to_tokens input =
  let words = Str.split (regexp "[ \t\n\r]+") input in
  List.map Lib.Parser.parse_token (List.filter (fun s -> s <> "") words)


let () =
  Arg.parse speclist set_filename usage_msg;
  let input_data = readPic () in
  let tokens = parse_string_to_tokens input_data in
  let picture = Lib.Parser.get_current_picture (Lib.Parser.process_tokens tokens) in

  if !display then begin
    Graphics.open_graph "";
    Graphics.set_window_title "OCaml Graphics";
    Graph.picture_to_graph !scale picture;
    ignore (Graphics.read_key ());
    Graphics.close_graph ();
  end else
    print_endline (Picture.picture_to_postscript !scale picture);
