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

    try
        let picture = Lib.Parser.get_current_picture (Lib.Parser.process_tokens tokens) in

        if !display then begin
            Graphics.open_graph "";
            Graphics.set_window_title "OCaml Graphics";
            Graph.picture_to_graph !scale picture;
            ignore (Graphics.read_key ());
            Graphics.close_graph ();
            end 
        else
            let sc = Picture.r_of_int !scale in
            let sc_pic = (Picture.scale sc picture) in
            print_endline (Picture.string_of_picture sc_pic);
    with
        | Failure _ ->
        if !display then begin
            Printf.eprintf "Error: Invalid input or processing failed.\n";
            exit 1
            end 
        else
            print_endline "/Courier findfont 24 scalefont setfont 0 0 moveto (Error) show"
