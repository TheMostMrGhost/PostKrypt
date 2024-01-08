open Lib.Picture
open Lib.Lexer
let () = print_endline "Hello, World!"


let () =
  let words = Lib.Inputpic.readPic () in
    List.iter (fun x -> print_endline x) (List.map Lib.Lexer.token_to_string words)
