open Lib.Picture
let () = print_endline "Hello, World!"


let () =
  let words = Lib.Inputpic.readPic () in
  List.iter (Printf.printf "%s\n") words
